# Interpreted GRASS 6+ interface functions
# Copyright (c) 2005-2010 Roger S. Bivand
#

readRAST6 <- function(vname, cat=NULL, ignore.stderr = FALSE, 
	NODATA=NULL, plugin=NULL, mapset=NULL, useGDAL=TRUE, close_OK=TRUE,
        drivername="GTiff") {
	if (!is.null(cat))
		if(length(vname) != length(cat)) 
			stop("vname and cat not same length")
    if (!is.null(plugin) && plugin && length(vname) > 1) plugin <- FALSE
    gdalD <- gdalDrivers()$name
    if (is.null(plugin)) {
	plugin <- "GRASS" %in% gdalD
        if (length(vname) > 1) plugin <- FALSE
        if (plugin) {
            gg <- gmeta6()
            if (is.null(mapset)) {
                c_at <- strsplit(vname[1], "@")[[1]]
                if (length(c_at) == 1) {
                    mapset <- .g_findfile(vname[1], type="cell")
                } else if (length(c_at) == 2) {
                    mapset <- c_at[2]
                    vname[1] <- c_at[1]
                } else stop("malformed raster name")
            }
            fname <- paste(gg$GISDBASE, gg$LOCATION_NAME, mapset,
                "cellhd", vname[1], sep="/")
            fninfo <- GDALinfo(fname)
            chks <- logical(4)
            names(chks) <- c("cols", "rows", "origin.northing",
                "origin.easting")
            chks[1] <- isTRUE(all.equal(abs((gg$w-gg$e)/gg$ewres), fninfo[2],
                tol=2e-7, check.attributes=FALSE))
            chks[2] <- isTRUE(all.equal(abs((gg$n-gg$s)/gg$nsres), fninfo[1],
                tol=2e-7, check.attributes=FALSE))
# changed from gg$n 100129, thanks to Rainer Krug
            chks[3] <- isTRUE(all.equal(gg$s, fninfo[5],
                check.attributes=FALSE))
            chks[4] <- isTRUE(all.equal(gg$w, fninfo[4],
                check.attributes=FALSE))
            if (any(!chks)) {
              plugin <- FALSE
              if (!ignore.stderr) {
                cat("raster map/current region mismatch detected in components:\n")
                print(chks)
		cat("set plugin=TRUE to override; continuing with plugin=FALSE\n") 
              }
            }
        }
    }
    if (plugin) {
	if (!("GRASS" %in% gdalD)) stop("no GRASS plugin driver")
        if (length(vname) > 1) stop("single raster required for plugin")
        if (!is.null(cat) && cat[1]) warning("cat not used for plugin")
        gg <- gmeta6()
        if (is.null(mapset)) {
            c_at <- strsplit(vname[1], "@")[[1]]
            if (length(c_at) == 1) {
                mapset <- .g_findfile(vname[1], type="cell")
            } else if (length(c_at) == 2) {
                mapset <- c_at[2]
                vname[1] <- c_at[1]
            } else stop("malformed raster name")
        }
        fname <- paste(gg$GISDBASE, gg$LOCATION_NAME, mapset,
            "cellhd", vname[1], sep="/")
        resa <- readGDAL(fname, silent=ignore.stderr)
	names(resa) <- make.names(vname)
	
    } else {
	pid <- as.integer(round(runif(1, 1, 1000)))
	p4 <- CRS(getLocationProj())
        Gver <- execGRASS("g.version", intern=TRUE, 
		ignore.stderr=ignore.stderr)
	G63 <- !(Gver < "GRASS 6.3") #Gver > "GRASS 6.2"

# 090311 fix for -c flag
        Cflag <- "c" %in% parseGRASS("r.out.gdal")$fnames
	for (i in seq(along=vname)) {


		whCELL <- execGRASS("r.info", flags="t",
		    parameters=list(map=vname[i]), intern=TRUE, 
		    ignore.stderr=ignore.stderr)

		to_int <- length(which(unlist(strsplit(
			whCELL, "=")) == "CELL")) > 0
                Dcell <- length(which(unlist(strsplit(
			whCELL, "=")) == "DCELL")) > 0

		gtmpfl1 <- dirname(execGRASS("g.tempfile",
		    parameters=list(pid=pid), intern=TRUE,
		    ignore.stderr=ignore.stderr))
		rtmpfl1 <- ifelse(.Platform$OS.type == "windows" &&
                        (Sys.getenv("OSTYPE") == "cygwin"), 
			system(paste("cygpath -w", gtmpfl1, sep=" "), 
			intern=TRUE), gtmpfl1)
		gtmpfl11 <- paste(gtmpfl1, vname[i], sep=.Platform$file.sep)
#                if (length(grep(" ", gtmpfl11)) > 0) 
#                    gtmpfl11 <- paste("\"", gtmpfl11, "\"", sep="")
		rtmpfl11 <- paste(rtmpfl1, vname[i], sep=.Platform$file.sep)

                if (!is.null(NODATA)) {
		    if (!is.finite(NODATA) || !is.numeric(NODATA))
			stop("invalid NODATA value")
		    if (NODATA != round(NODATA)) 
			warning("NODATA rounded to integer")
		    NODATA <- round(NODATA)
		}
		if (useGDAL && G63) {
                    gdalDGRASS <- execGRASS("r.out.gdal", flags="l",
                        intern=TRUE, ignore.stderr=TRUE)
	            if (!(drivername %in% gdalD))
                        stop(paste("Requested driver", drivername,
                            "not available in rgdal"))
                    if (length(grep(drivername, gdalDGRASS)) == 0)
                        stop(paste("Requested driver", drivername,
                            "not available in GRASS"))
		    type <- ifelse (to_int, "Int32",
                        ifelse(Dcell, "Float64", "Float32"))
                    flags <- c("quiet")
                    if (Cflag) flags <- c("c", flags)
                    paras <- list(input=vname[i], output=gtmpfl11, type=type,
                        format=drivername)
                    if (!is.null(NODATA)) paras <- c(paras, nodata=NODATA)
                    execGRASS("r.out.gdal", flags=flags,
			parameters=paras, ignore.stderr=ignore.stderr)

		    res <- readGDAL(rtmpfl11, p4s=getLocationProj(), 
			silent=ignore.stderr)
		    names(res) <- vname[i]
                    DS <- GDAL.open(rtmpfl11, read.only=FALSE)
                    deleteDataset(DS)
		} else {
# 061107 Dylan Beaudette NODATA
# 071009 Markus Neteler's idea to use range
	  	    if (is.null(NODATA)) {
		      tx <- execGRASS("r.info", flags="r",
		        parameters=list(map=vname[i]), intern=TRUE, 
		        ignore.stderr=ignore.stderr)
		      tx <- gsub("=", ":", tx)
		      con <- textConnection(tx)
		      res <- read.dcf(con)
		      close(con)
		      lres <- as.list(res)
		      names(lres) <- colnames(res)
		      lres <- lapply(lres, as.numeric)
		      if (!is.numeric(lres$min) || 
			!is.finite(as.double(lres$min))) 
			    NODATA <- as.integer(999)
		      else {
			lres$min <- floor(as.double(lres$min))
		        NODATA <- floor(lres$min) - 1
		      }
                    }
		    execGRASS("r.out.bin", flags="b", 
			parameters=list(input=vname[i], output=gtmpfl11, 
			null=as.integer(NODATA)), ignore.stderr=ignore.stderr)

		    res <- readBinGrid(rtmpfl11, colname=vname[i], 
			proj4string=p4,	integer=to_int)
		    unlink(paste(rtmpfl1, list.files(rtmpfl1,
                        pattern=vname[i]), sep=.Platform$file.sep))
		}


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

	if (close_OK) closeAllConnections()

	if (!is.null(cat)) {
		for (i in seq(along=cat)) {
			if (cat[i] && is.integer(resa@data[[i]])) {

				rSTATS <- execGRASS("r.stats",
				    flags=c("l", "quiet"),
				    parameters=list(input=vname[i]),
				    intern=TRUE, ignore.stderr=ignore.stderr)

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

	res <- SpatialGridDataFrame(grid, data = df1, proj4string=proj4string)
	res
}

writeRAST6 <- function(x, vname, zcol = 1, NODATA=NULL, 
	ignore.stderr = FALSE, useGDAL=TRUE, overwrite=FALSE, flags=NULL,
        drivername="GTiff") {


	pid <- as.integer(round(runif(1, 1, 1000)))
	gtmpfl1 <- dirname(execGRASS("g.tempfile", parameters=list(pid=pid),
	    intern=TRUE, ignore.stderr=ignore.stderr))

	rtmpfl1 <- ifelse(.Platform$OS.type == "windows" &&
                (Sys.getenv("OSTYPE") == "cygwin"), 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE), 
		gtmpfl1)

	fid <- paste("X", pid, sep="")
	gtmpfl11 <- paste(gtmpfl1, fid, sep=.Platform$file.sep)
	rtmpfl11 <- paste(rtmpfl1, fid, sep=.Platform$file.sep)
	if (!is.numeric(x@data[[zcol]])) 
		stop("only numeric columns may be exported")
	if (overwrite && !("overwrite" %in% flags))
		flags <- c(flags, "overwrite")
        Gver <- execGRASS("g.version", intern=TRUE, 
		ignore.stderr=ignore.stderr)
	G63 <- !(Gver < "GRASS 6.3") #Gver > "GRASS 6.2"
	if (useGDAL && G63) {
            gdalD <- gdalDrivers()$name
            gdalDGRASS <- execGRASS("r.out.gdal", flags="l",
                intern=TRUE, ignore.stderr=TRUE)
	    if (!(drivername %in% gdalD))
                stop(paste("Requested driver", drivername,
                    "not available in rgdal"))
            if (length(grep(drivername, gdalDGRASS)) == 0)
                stop(paste("Requested driver", drivername,
                    "not available in GRASS"))
	    if (is.factor(x@data[[zcol]])) 
		x@data[[zcol]] <- as.numeric(x@data[[zcol]])
	    if (!is.numeric(x@data[[zcol]])) 
		stop("only numeric values may be exported")
	    if (is.null(NODATA)) {
		NODATA <- floor(min(x@data[[zcol]], na.rm=TRUE)) - 1
	    } else {
		if (!is.finite(NODATA) || !is.numeric(NODATA))
			stop("invalid NODATA value")
		if (NODATA != round(NODATA)) 
			warning("NODATA rounded to integer")
		NODATA <- round(NODATA)
	    }
	    sm <- storage.mode(x[[zcol]])
	    type <- ifelse(sm == "integer", "Int32", "Float32")
	    res <- writeGDAL(x[zcol], fname=rtmpfl11, type=type, 
		drivername=drivername, mvFlag = NODATA)

	    execGRASS("r.in.gdal", flags=flags, parameters=list(input=gtmpfl11,
		output=vname), ignore.stderr=ignore.stderr)

            DS <- GDAL.open(rtmpfl11, read.only=FALSE)
            deleteDataset(DS)
	} else {
	    res <- writeBinGrid(x, rtmpfl11, attr = zcol, na.value = NODATA)

	    flags <- c(res$flag, flags)
	    
	    execGRASS("r.in.bin", flags=res$flag,
                parameters=list(input=gtmpfl11,
		output=vname, bytes=as.integer(res$bytes), 
		north=as.numeric(res$north), south=as.numeric(res$south), 
		east=as.numeric(res$east), west=as.numeric(res$west), 
		rows=as.integer(res$rows), cols=as.integer(res$cols), 
		anull=as.numeric(res$anull)), ignore.stderr=ignore.stderr)

	    unlink(paste(rtmpfl1, list.files(rtmpfl1, pattern=fid), 
		sep=.Platform$file.sep))
	}

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
	z[is.na(z)] = na.value
	if (storage.mode(z) == "integer") {
		sz <- 4
		res$flag <- NULL
	} else if (storage.mode(z) == "double") {
		sz <- 4
		res$flag <- "f"
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

