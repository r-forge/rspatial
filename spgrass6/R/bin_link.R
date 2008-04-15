# Interpreted GRASS 6 interface functions
# Copyright (c) 2005-7 Roger S. Bivand
#

readRAST6 <- function(vname, cat=NULL, ignore.stderr = FALSE, 
	NODATA=NULL) {
	if (!is.null(cat))
		if(length(vname) != length(cat)) 
			stop("vname and cat not same length")

	pid <- as.integer(round(runif(1, 1, 1000)))
	p4 <- CRS(getLocationProj())
	for (i in seq(along=vname)) {

		cmd <- paste(paste("r.info", .addexe(), sep=""),
                    " -t", vname[i])

		tull <- ifelse(.Platform$OS.type == "windows", 
			whCELL <- system(cmd, intern=TRUE), 
			whCELL <- system(cmd, intern=TRUE, 
			ignore.stderr=ignore.stderr))
		to_int <- length(which(unlist(strsplit(
			whCELL, "=")) == "CELL")) > 0

		cmd <- paste(paste("g.tempfile", .addexe(), sep=""),
                    " pid=", pid, sep="")

		gtmpfl1 <- dirname(ifelse(.Platform$OS.type == "windows", 
			system(cmd, intern=TRUE), system(cmd, intern=TRUE, 
			ignore.stderr=ignore.stderr)))
		rtmpfl1 <- ifelse(.Platform$OS.type == "windows" &&
                        (Sys.getenv("OSTYPE") == "cygwin"), 
			system(paste("cygpath -w", gtmpfl1, sep=" "), 
			intern=TRUE), gtmpfl1)
		gtmpfl11 <- paste(gtmpfl1, vname[i], sep=.Platform$file.sep)
		rtmpfl11 <- paste(rtmpfl1, vname[i], sep=.Platform$file.sep)

# 071009 Markus Neteler's idea to use range
		if (is.null(NODATA)) {
		    cmd <- paste(paste("r.info", .addexe(), sep=""),
                        " -r", vname[i])

		    tull <- ifelse(.Platform$OS.type == "windows", 
			tx <- system(cmd, intern=TRUE), 
			tx <- system(cmd, intern=TRUE, 
			ignore.stderr=ignore.stderr))
		    tx <- gsub("=", ":", tx)
		    con <- textConnection(tx)
		    res <- read.dcf(con)
		    close(con)
		    lres <- as.list(res)
		    names(lres) <- colnames(res)
		    lres$min <- floor(as.double(lres$min))
		    vNODATA <- floor(lres$min) - 1
		} else {
		    if (!is.finite(NODATA) || !is.numeric(NODATA))
			stop("invalid NODATA value")
		    if (NODATA != round(NODATA)) 
			warning("NODATA rounded to integer")
		    vNODATA <- round(NODATA)
		}

		cmd <- paste(paste("r.out.bin", .addexe(), sep=""),
                    " -b input=", vname[i], " output=", gtmpfl11,
                    " null=", vNODATA, sep="")

# 061107 Dylan Beaudette NODATA

		tull <- ifelse(.Platform$OS.type == "windows", system(cmd), 
			system(cmd, ignore.stderr=ignore.stderr))

		res <- readBinGrid(rtmpfl11, colname=vname[i], proj4string=p4,
			integer=to_int)

		unlink(paste(rtmpfl1, list.files(rtmpfl1, pattern=vname[i]), 
			sep=.Platform$file.sep))

		if (i == 1) resa <- res
		else {
			grida <- getGridTopology(resa)
			grid <- getGridTopology(res)
			if (!isTRUE(all.equal(grida, grid)))
				stop("topology is not equal")
			onames <- c(names(resa@data), names(res@data))
			ncols <- dim(resa@data)[2]
			lst <- vector(mode="list", length=ncols+1)
			names(lst) <- onames
			for (i in 1:ncols) lst[[i]] <- resa@data[[i]]
			lst[[ncols+1]] <- res@data[[1]]
			df <- data.frame(lst)
			resa <- SpatialGridDataFrame(grid=grida, 
				data=df, proj4string=p4)
		}
	}

	if (!is.null(cat)) {
		cmd <- paste("g.version", .addexe(), sep="")
		tull <- ifelse(.Platform$OS.type=="windows",
			Gver <- system(cmd, intern=TRUE), 
			Gver <- system(cmd, intern=TRUE, 
			ignore.stderr=ignore.stderr))
		G63 <- !(Gver < "GRASS 6.3") #Gver > "GRASS 6.2"
		for (i in seq(along=cat)) {
			if (cat[i] && is.integer(resa@data[[i]])) {

# note --q in 6.3.cvs
				if (G63) cmd <- paste(paste("r.stats", 
				    .addexe(), sep=""), "-l --q", vname[i])
				else cmd <- paste(paste("r.stats", .addexe(),
                                    sep=""), "-l -q", vname[i])

				tull <- ifelse(.Platform$OS.type=="windows",
				    rSTATS <- system(cmd, intern=TRUE), 
				    rSTATS <- system(cmd, intern=TRUE, 
				    ignore.stderr=ignore.stderr))
#				if ((length(rSTATS) == 0)
#                                    || (length(grep("Sorry", rSTATS[1])) > 0)) {
#				    cmd <- paste(paste("r.stats", .addexe(),
#                                        sep=""), "-l --q", vname[i])
#				    tull <- ifelse(.Platform$OS.type=="windows",
#				    rSTATS <- system(cmd, intern=TRUE),
#				    rSTATS <- system(cmd, intern=TRUE,
#				    ignore.stderr=ignore.stderr))
#				}

				cats <- strsplit(rSTATS, " ")
				catnos <- sapply(cats, function(x) x[1])
				catlabs <- sapply(cats, 
					function(x) paste(x[-1], collapse=" "))
				if (any(!is.na(match(catnos, "*")))) {
					isNA <- which(catnos == "*")
					catnos <- catnos[-isNA]
					catlabs <- catlabs[-isNA]
				}
				resa@data[[i]] <- factor(resa@data[[i]], 
					levels=catnos, labels=catlabs)
			}
		}
	} 
	resa
}

readBinGrid <- function(fname, colname=basename(fname), 
	proj4string=CRS(as.character(NA)), integer) {
	if (missing(integer)) stop("integer TRUE/FALSE required")
	if (!file.exists(fname)) stop(paste("no such file:", fname))
	if (!file.exists(paste(fname, "hdr", sep="."))) 
		stop(paste("no such file:", paste(fname, "hdr", sep=".")))
	if (!file.exists(paste(fname, "wld", sep="."))) 
		stop(paste("no such file:", paste(fname, "wld", sep=".")))
	con <- file(paste(fname, "hdr", sep="."), "r")
	l8 <- readLines(con, n=8)
	close(con)
	l8 <- read.dcf(con <- textConnection(gsub(" ", ":", l8)))
	close(con)
	lres <- as.list(l8)
	names(lres) <- colnames(l8)
	lres$nrows <- as.integer(lres$nrows)
	lres$ncols <- as.integer(lres$ncols)
	lres$nbands <- as.integer(lres$nbands)
	lres$nbits <- as.integer(lres$nbits)
	lres$skipbytes <- as.integer(lres$skipbytes)
	lres$nodata <- ifelse(integer, as.integer(lres$nodata), 
		as.numeric(lres$nodata))
	lres$byteorder <- as.character(lres$byteorder)
	endian <- .Platform$endian
	if ((endian == "little" && lres$byteorder == "M") ||
		(endian == "big" && lres$byteorder == "I")) endian <- "swap"
	con <- file(paste(fname, "wld", sep="."), "r")
	l6 <- readLines(con, n=6)
	close(con)
	lres$ewres <- abs(as.numeric(l6[1]))
	lres$nsres <- abs(as.numeric(l6[4]))
	lres$n_cc <- as.numeric(l6[6])
	lres$w_cc <- as.numeric(l6[5])
	lres$s_cc <- lres$n_cc - lres$nsres * (lres$nrows-1)

	what <- ifelse(integer, "integer", "double")
	n <- lres$nrows * lres$ncols
	size <- lres$nbits/8
	map <- readBin(fname, what=what, n=n, size=size, signed=TRUE,
		endian=endian)
	is.na(map) <- map == lres$nodata
	grid = GridTopology(c(lres$w_cc, lres$s_cc), 
		c(lres$ewres, lres$nsres), c(lres$ncols,lres$nrows))
	df <- list(var1=map)
	names(df) <- colname
	df1 <- data.frame(df)
# long processing time 071006 - solution centralised in sp
#        pts = sp:::boguspoints(grid)
#	pts@bbox[,1] = pts@bbox[,1] - 0.5 * grid@cellsize
#	pts@bbox[,2] = pts@bbox[,2] + 0.5 * grid@cellsize
#	res <- new("SpatialGridDataFrame")
#        slot(res, "data") <- df1
#	slot(res, "grid") <- grid
#        slot(res, "grid.index") <- integer(0)
#        slot(res, "coords") <- slot(pts, "coords")
#        slot(res, "bbox") <- slot(pts, "bbox")
#        slot(res, "proj4string") <- proj4string

	res <- SpatialGridDataFrame(grid, data = df1, proj4string=proj4string)
	res
}

writeRAST6 <- function(x, vname, zcol = 1, NODATA=NULL, 
	ignore.stderr = FALSE) {


	pid <- round(runif(1, 1, 1000))
	cmd <- paste(paste("g.tempfile", .addexe(), sep=""),
            " pid=", pid, sep="")

	gtmpfl1 <- dirname(ifelse(.Platform$OS.type == "windows",
		system(cmd, intern=TRUE),
		system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)))

	rtmpfl1 <- ifelse(.Platform$OS.type == "windows" &&
                (Sys.getenv("OSTYPE") == "cygwin"), 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE), 
		gtmpfl1)

	fid <- paste("X", pid, sep="")
	gtmpfl11 <- paste(gtmpfl1, fid, sep=.Platform$file.sep)
	rtmpfl11 <- paste(rtmpfl1, fid, sep=.Platform$file.sep)
	if (!is.numeric(x@data[[zcol]])) 
		stop("only numeric columns may be exported")
	
	res <- writeBinGrid(x, rtmpfl11, attr = zcol, na.value = NODATA)

	cmd <- paste(paste("r.in.bin", .addexe(), sep=""),
                " ", res$flag, " input=", gtmpfl11, " output=", 
		vname, " bytes=", res$bytes, " north=", res$north, 
		" south=", res$south, " east=", res$east, " west=", 
		res$west, " rows=", res$rows, " cols=", res$cols, " anull=", 
		res$anull, sep="")
	
	tull <- ifelse(.Platform$OS.type == "windows", 
		system(cmd), system(cmd, ignore.stderr=ignore.stderr))

	unlink(paste(rtmpfl1, list.files(rtmpfl1, pattern=fid), 
		sep=.Platform$file.sep))
	invisible(res)
}

writeBinGrid <- function(x, fname, attr = 1, na.value = NULL) { 
	if (!gridded(x))
		stop("can only write SpatialGridDataFrame objects to binary grid")
	x = as(x, "SpatialGridDataFrame")
	gp = gridparameters(x)
	if (length(gp$cells.dim) != 2)
		stop("binary grid only supports 2D grids")
	z = x@data[[attr]]
	if (is.factor(z)) z <- as.numeric(z)
	if (!is.numeric(z)) stop("only numeric values may be exported")
	if (is.null(na.value)) {
		na.value <- floor(min(z, na.rm=TRUE)) - 1
	} else {
		if (!is.finite(na.value) || !is.numeric(na.value))
			stop("invalid NODATA value")
		if (na.value != round(na.value)) 
			warning("NODATA rounded to integer")
		na.value <- round(na.value)
	}
	res <- list()
	res$anull <- formatC(na.value, format="d")
#	if (is.integer(z)) {
#		na.value <- as.integer(na.value)
#		res$anull <- formatC(as.integer(na.value), format="d")
#	}
	z[is.na(z)] = na.value
	if (storage.mode(z) == "integer") {
		sz <- 4
		res$flag <- ""
	} else if (storage.mode(z) == "double") {
		sz <- 4
		res$flag <- "-f"
	} else stop("unknown storage mode")
	res$bytes <- formatC(sz, format="d")
	f = file(fname, open = "wb")
	writeBin(z, con=f, size=sz)
	close(f)
	grd <- slot(x, "grid")
	f = file(paste(fname, "hdr", sep="."), open = "wt")
	writeLines(paste("nrows", grd@cells.dim[2]), f)
	res$rows <- formatC(grd@cells.dim[2], format="d")
	writeLines(paste("ncols", grd@cells.dim[1]), f)
	res$cols <- formatC(grd@cells.dim[1], format="d")
	writeLines(paste("nbands 1"), f)
	writeLines(paste("nbits", 8*sz), f)
	writeLines(paste("byteorder", ifelse(.Platform$endian == "little", 
		"I", "M")), f)
	writeLines(paste("layout bil"), f)
	writeLines(paste("skipbytes 0"), f)
	writeLines(paste("nodata", na.value), f)
	close(f)
	f = file(paste(fname, "wld", sep="."), open = "wt")
	writeLines(formatC(grd@cellsize[1], format="f"), f)
	writeLines("0.0", f)
	writeLines("0.0", f)
	writeLines(formatC(-grd@cellsize[2], format="f"), f)
	writeLines(formatC(grd@cellcentre.offset[1], format="f"), f)
	writeLines(formatC((grd@cellcentre.offset[2] +
		grd@cellsize[2]*(grd@cells.dim[2]-1)), format="f"), f)
	close(f)
	res$north <- formatC((grd@cellcentre.offset[2] +
		grd@cellsize[2]*(grd@cells.dim[2]-1)
		+ 0.5*grd@cellsize[2]), format="f")
	res$south <- formatC(grd@cellcentre.offset[2] - 0.5*grd@cellsize[2], 
		format="f")
	res$east <- formatC((grd@cellcentre.offset[1] + 
		grd@cellsize[1]*(grd@cells.dim[1]-1) + 0.5*grd@cellsize[1]), 
		format="f")
	res$west <- formatC(grd@cellcentre.offset[1] - 0.5*grd@cellsize[1], 
		format="f")
	invisible(res)
}

