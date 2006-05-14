# Interpreted GRASS 6 interface functions
# Copyright (c) 2005 Roger S. Bivand
#

gmeta6 <- function(ignore.stderr = FALSE) {
	tx <- system("g.region -p3", intern=TRUE, ignore.stderr=ignore.stderr)
	res <- read.dcf(textConnection(tx))
	lres <- as.list(res)
	names(lres) <- colnames(res)
	lres$north <- as.double(lres$north)
	lres$south <- as.double(lres$south)
	lres$west <- as.double(lres$west)
	lres$east <- as.double(lres$east)
	lres$top <- as.double(lres$top)
	lres$bottom <- as.double(lres$bottom)
	lres$nsres <- as.double(lres$nsres)
	lres$nsres3 <- as.double(lres$nsres3)
	lres$ewres <- as.double(lres$ewres)
	lres$ewres3 <- as.double(lres$ewres3)
	lres$tbres <- as.double(lres$tbres)
	lres$rows <- as.integer(lres$rows)
	lres$rows3 <- as.integer(lres$rows3)
	lres$cols <- as.integer(lres$cols)
	lres$cols3 <- as.integer(lres$cols3)
	lres$depths <- as.integer(lres$depths)
	lres$proj4 <- getLocationProj()
	gisenv <- gsub("[';]", "", system("g.gisenv", intern=TRUE, ignore.stderr=ignore.stderr))
	gisenv <- strsplit(gisenv, "=")
	glist <- as.list(sapply(gisenv, function(x) x[2]))
	names(glist) <- sapply(gisenv, function(x) x[1])
	lres <- c(glist, lres)
	lres
}

getSites6 <- function(vname, ignore.stderr = FALSE) {
# based on suggestions by Miha Staut using v.out.ascii and v.db.select,
# modified to avoid cygwin problems
	SPDF <- getSites6sp(vname, ignore.stderr=ignore.stderr)
	res <- as(SPDF, "data.frame")
	res
}

getSites6sp <- function(vname, ignore.stderr = FALSE) {
	pid <- as.integer(round(runif(1, 1, 1000)))
	gtmpfl1 <- dirname(system(paste("g.tempfile pid=", pid, sep=""), 
		intern=TRUE, ignore.stderr=ignore.stderr))
	rtmpfl1 <- ifelse(.Platform$OS.type == "windows", 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE, ignore.stderr=ignore.stderr), 
		gtmpfl1)
	shname <- substring(vname, 1, ifelse(nchar(vname) > 8, 8, 
		nchar(vname)))
	system(paste("v.out.ogr input=", vname, " type=point dsn=", 
		gtmpfl1, " olayer=", shname, sep=""), ignore.stderr=ignore.stderr)
	p4 <- CRS(getLocationProj())
	res <- readShapePoints(paste(rtmpfl1, shname, sep=.Platform$file.sep), 
		proj4string=p4)
	unlink(paste(rtmpfl1, list.files(rtmpfl1, pattern=shname), 
		sep=.Platform$file.sep))
	res
}


putSites6 <- function(df, vname, ignore.stderr = FALSE) {
# based on suggestions by Miha Staut using v.out.ascii and v.db.select,
# modified to avoid cygwin problems
	coordinates(df) <- c("x", "y")
	putSites6sp(df, vname, ignore.stderr=ignore.stderr)
}

putSites6sp <- function(SPDF, vname, factor2char = TRUE, ignore.stderr = FALSE) {
	pid <- as.integer(round(runif(1, 1, 1000)))
	gtmpfl1 <- dirname(system(paste("g.tempfile pid=", pid, sep=""), 
		intern=TRUE, ignore.stderr=ignore.stderr))
	rtmpfl1 <- ifelse(.Platform$OS.type == "windows", 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE, ignore.stderr=ignore.stderr), 
		gtmpfl1)
	shname <- substring(vname, 1, ifelse(nchar(vname) > 8, 8, 
		nchar(vname)))
	writePointsShape(SPDF, paste(rtmpfl1, shname, sep=.Platform$file.sep),
		factor2char=factor2char)
	system(paste("v.in.ogr -o dsn=", gtmpfl1, " output=", vname, 
		" layer=", shname, " type=point", sep=""), ignore.stderr=ignore.stderr)
	unlink(paste(rtmpfl1, list.files(rtmpfl1, pattern=shname), 
		sep=.Platform$file.sep))
}


getLocationProj <- function(ignore.stderr = FALSE) {
# too strict assumption on g.proj Rohan Sadler 20050928
	projstr <- system("g.proj -j -f", intern=TRUE, ignore.stderr=ignore.stderr)
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
		gtmpfl1 <- system(paste("g.tempfile pid=", pid, sep=""), 
			intern=TRUE, ignore.stderr=ignore.stderr)
		rtmpfl1 <- ifelse(.Platform$OS.type == "windows", 
			system(paste("cygpath -w", gtmpfl1, sep=" "), 
			intern=TRUE, ignore.stderr=ignore.stderr), gtmpfl1)
		system(paste("r.out.arc input=", vname[i], " output=", 
			gtmpfl1, sep=""), ignore.stderr=ignore.stderr)
		res <- readAsciiGrid(rtmpfl1, colname=vname[i], proj4string=p4)
		to_int <- length(which(unlist(strsplit(system(paste(
		    "r.info -t", vname[i]), intern=TRUE, ignore.stderr=ignore.stderr), "=")) == "CELL")) > 0
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
			resa <- SpatialGridDataFrame(grid=grida, 
				data=AttributeList(lst), proj4string=p4)
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
				cats <- strsplit(system(paste("r.stats -l -q", 
					vname[i]), intern=TRUE, ignore.stderr=ignore.stderr), " ")
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
	gtmpfl1 <- system(paste("g.tempfile pid=", pid, sep=""), 
		intern=TRUE, ignore.stderr=ignore.stderr)
	rtmpfl1 <- ifelse(.Platform$OS.type == "windows", 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE, 
			ignore.stderr=ignore.stderr), gtmpfl1)
	if (!is.numeric(x@data[[zcol]])) 
		stop("only numeric columns may be exported")
	writeAsciiGrid(x, rtmpfl1, attr = zcol, na.value = NODATA)
	system(paste("r.in.gdal -o input=", gtmpfl1, " output=", vname, sep=""), ignore.stderr=ignore.stderr)
	unlink(rtmpfl1)
}



