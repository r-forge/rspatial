# Interpreted GRASS 6 interface functions
# Copyright (c) 2005-8 Roger S. Bivand
#

gmeta6 <- function(ignore.stderr = FALSE) {
	tull <- ifelse(.Platform$OS.type == "windows",
		tx <- system(paste(paste("g.region", .addexe(), sep=""),
                          "-g3"), intern=TRUE), 
		tx <- system("g.region -g3", 
		          intern=TRUE, ignore.stderr=ignore.stderr))	
	tx <- gsub("=", ":", tx)
	con <- textConnection(tx)
	res <- read.dcf(con)
	close(con)
	lres <- as.list(res)
	names(lres) <- colnames(res)
	lres$n <- as.double(lres$n)
	lres$s <- as.double(lres$s)
	lres$w <- as.double(lres$w)
	lres$e <- as.double(lres$e)
	lres$t <- as.double(lres$t)
	lres$b <- as.double(lres$b)
	lres$nsres <- as.double(lres$nsres)
	lres$nsres3 <- as.double(lres$nsres3)
	lres$ewres <- as.double(lres$ewres)
	lres$ewres3 <- as.double(lres$ewres3)
	lres$tbres <- as.double(lres$tbres)
	if (length(lres$rows) == 0) 
		lres$rows <- abs(as.integer((lres$n-lres$s)/lres$nsres))
	else lres$rows <- as.integer(lres$rows)
	if (length(lres$rows3) == 0) lres$rows3 <- lres$rows
	else lres$rows3 <- as.integer(lres$rows3)
	if (length(lres$cols) == 0) 
		lres$cols <- abs(as.integer((lres$e-lres$w)/lres$ewres))
	else lres$cols <- as.integer(lres$cols)
	if (length(lres$cols3) == 0) lres$cols3 <- lres$cols
	else lres$cols3 <- as.integer(lres$cols3)
	if (length(lres$depths) == 0) 
		lres$depths <- abs(as.integer((lres$t-lres$b)/lres$tbres))
	else lres$depths <- as.integer(lres$depths)
	lres$proj4 <- getLocationProj()
	tull <- ifelse(.Platform$OS.type == "windows", 
		gisenv <- system(paste("g.gisenv", .addexe(), sep=""),
                              intern=TRUE), 
		gisenv <- system("g.gisenv", 
		              intern=TRUE, ignore.stderr=ignore.stderr))
	gisenv <- gsub("[';]", "", gisenv)
	gisenv <- strsplit(gisenv, "=")
	glist <- as.list(sapply(gisenv, function(x) x[2]))
	names(glist) <- sapply(gisenv, function(x) x[1])
	lres <- c(glist, lres)
	class(lres) <- "gmeta6"
	lres
}

print.gmeta6 <- function(x, ...) {
    cat("gisdbase   ", x$GISDBASE, "\n")
    cat("location   ", x$LOCATION_NAME, "\n")
    cat("mapset     ", x$MAPSET, "\n")
    cat("rows       ", x$rows, "\n")
    cat("columns    ", x$cols, "\n")
    cat("north      ", x$n, "\n")
    cat("south      ", x$s, "\n")
    cat("west       ", x$w, "\n")
    cat("east       ", x$e, "\n")
    cat("nsres      ", x$nsres, "\n")
    cat("ewres      ", x$ewres, "\n")
    cat("projection ", paste(strwrap(x$proj4), collapse="\n"), "\n")
    invisible(x)
}

gmeta2grd <- function(ignore.stderr = FALSE) {
	G <- gmeta6(ignore.stderr=ignore.stderr)
	cellcentre.offset <- c(G$w+(G$ewres/2), G$s+(G$nsres/2))
	cellsize <- c(G$ewres, G$nsres)
	cells.dim <- c(G$cols, G$rows)
	grd <- GridTopology(cellcentre.offset=cellcentre.offset, 
		cellsize=cellsize, cells.dim=cells.dim)
	grd
}



getLocationProj <- function(ignore.stderr = FALSE) {
# too strict assumption on g.proj Rohan Sadler 20050928
	ifelse(.Platform$OS.type == "windows", 
		projstr <- system(paste(paste("g.proj", .addexe(), sep=""),
                               "-j -f"), intern=TRUE), 
		projstr <- system("g.proj -j -f", intern=TRUE, 
		               ignore.stderr=ignore.stderr))
	if (length(grep("XY location", projstr)) > 0)
		projstr <- as.character(NA)
	if (length(grep("latlong", projstr)) > 0)
		projstr <- sub("latlong", "longlat", projstr)
    	if (is.na(projstr)) uprojargs <- projstr
    	else uprojargs <- paste(unique(unlist(strsplit(projstr, " "))), 
		collapse=" ")
    	if (length(grep("= ", uprojargs)) != 0) {
		warning(paste("No spaces permitted in PROJ4",
			"argument-value pairs:", uprojargs))
		uprojargs <- as.character(NA)
	}
    	if (length(grep(" [:alnum:]", uprojargs)) != 0) {
		warning(paste("PROJ4 argument-value pairs",
			"must begin with +:", uprojargs))
		uprojargs <- as.character(NA)
	}
	uprojargs
}

readFLOAT6sp <- function(vname, ignore.stderr = FALSE) {
	pid <- as.integer(round(runif(1, 1, 1000)))
	p4 <- CRS(getLocationProj())
	for (i in seq(along=vname)) {
		gtmpfl1 <- ifelse(.Platform$OS.type == "windows", 
			system(paste(paste("g.tempfile", .addexe(), sep=""),
                            "pid=", pid, sep=""), intern=TRUE),
                        system(paste("g.tempfile pid=", pid, sep=""),
                            intern=TRUE, ignore.stderr=ignore.stderr))
		rtmpfl1 <- ifelse((.Platform$OS.type == "windows") &&
                        (Sys.getenv("OSTYPE") == "cygwin"), 
			system(paste("cygpath -w", gtmpfl1, sep=" "), 
			intern=TRUE), gtmpfl1)
		tull <- ifelse(.Platform$OS.type == "windows", system(paste(
			paste("r.out.arc", .addexe(), sep=""),
                        " input=", vname[i], " output=", gtmpfl1, sep="")), 
			system(paste("r.out.arc input=", vname[i], " output=", 
			gtmpfl1, sep=""), ignore.stderr=ignore.stderr))
		res <- readGDAL(rtmpfl1)
		names(res) <- vname[i]
		proj4string(res) <- p4
		tull <- ifelse(.Platform$OS.type == "windows", 
			whCELL <- system(paste(paste("r.info", .addexe(),
                                      sep=""), "-t", vname[i]), intern=TRUE), 
			whCELL <- system(paste("r.info -t", vname[i]), 
			intern=TRUE, ignore.stderr=ignore.stderr))
		to_int <- length(which(unlist(strsplit(
			whCELL, "=")) == "CELL")) > 0
		if (to_int) res@data[[1]] <- as.integer(res@data[[1]])
		unlink(rtmpfl1)
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
	resa
}

readCELL6sp <- function(vname, cat=NULL, ignore.stderr = FALSE) {
	if (!is.null(cat))
		if(length(vname) != length(cat)) 
			stop("vname and cat not same length")
	res <- readFLOAT6sp(vname, ignore.stderr=ignore.stderr)
	if (!is.null(cat)) {
		for (i in seq(along=cat)) {
			if (cat[i] && is.integer(res@data[[i]])) {
# note --q in 6.3.cvs
				cmd <- paste(paste("r.stats", .addexe(),
                                    sep=""), " -l -q", vname[i])

				tull <- ifelse(.Platform$OS.type=="windows",
				    rSTATS <- system(cmd, intern=TRUE), 
				    rSTATS <- system(cmd, intern=TRUE, 
				    ignore.stderr=ignore.stderr))
				if (length(rSTATS) == 0) {
				    cmd <- paste(paste("r.stats", .addexe(),
                                        sep=""), "-l --q", vname[i])
				    tull <- ifelse(.Platform$OS.type=="windows",
				    rSTATS <- system(cmd, intern=TRUE),
				    rSTATS <- system(cmd, intern=TRUE,
				    ignore.stderr=ignore.stderr))
				}
				cats <- strsplit(rSTATS, " ")
				catnos <- sapply(cats, function(x) x[1])
				catlabs <- sapply(cats, 
					function(x) paste(x[-1], collapse=" "))
				if (any(!is.na(match(catnos, "*")))) {
					isNA <- which(catnos == "*")
					catnos <- catnos[-isNA]
					catlabs <- catlabs[-isNA]
				}
				res@data[[i]] <- factor(res@data[[i]], 
					levels=catnos, labels=catlabs)
			}
		}
	} 
	res
}

rast.get6 <- function(vname, cat=NULL, ignore.stderr = FALSE) {
	readCELL6sp(vname=vname, cat=cat, ignore.stderr=ignore.stderr)
}

rast.put6 <- function(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE) {
	writeRast6sp(x=x, vname=vname, zcol=zcol, NODATA=NODATA, ignore.stderr=ignore.stderr)
}


writeRast6sp <- function(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE) {
	pid <- as.integer(round(runif(1, 1, 1000)))
	gtmpfl1 <- ifelse(.Platform$OS.type == "windows",
		system(paste(paste("g.tempfile", .addexe(), sep=""),
                    "pid=", pid, sep=""), intern=TRUE),
		system(paste("g.tempfile pid=", pid, sep=""), 
		    intern=TRUE, ignore.stderr=ignore.stderr))
	rtmpfl1 <- ifelse(.Platform$OS.type == "windows" &&
                (Sys.getenv("OSTYPE") == "cygwin"), 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE), 
		gtmpfl1)
	if (!is.numeric(x@data[[zcol]])) 
		stop("only numeric columns may be exported")
	writeGDAL(x[zcol], rtmpfl1, drivername="AAIGrid", mvFlag = NODATA)
	tull <- ifelse(.Platform$OS.type == "windows", 
		system(paste(paste("r.in.gdal", .addexe(), sep=""),
                   " -o input=", gtmpfl1, " output=", vname, sep="")), 
		system(paste("r.in.gdal -o input=", gtmpfl1, " output=", 
			vname, sep=""), ignore.stderr=ignore.stderr))
	unlink(rtmpfl1)
}


.addexe <- function() {
    res <- ""
    if (Sys.getenv("OSTYPE") == "msys") res =".exe"
    if (nchar(Sys.getenv("OSTYPE")) == 0 &&
        nchar(Sys.getenv("WINGISRC")) > 0) res =".exe"
    if (Sys.getenv("OSTYPE") == "cygwin") res =".exe"
    res
}
