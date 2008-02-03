# Interpreted GRASS 6 interface functions
# Copyright (c) 2005-7 Roger S. Bivand
#
readVECT6 <- function(vname, type=NULL, remove.duplicates=TRUE, ignore.stderr = FALSE, with_prj=TRUE, with_c=FALSE) {

	vinfo <- vInfo(vname)
	types <- names(vinfo)[which(vinfo > 0)]
	if (is.null(type)) {
		if (length(grep("points", types)) > 0) type <- "point"
		if (length(grep("lines", types)) > 0) type <- "line"
		if (length(grep("areas", types)) > 0) type <- "area"
		if (is.null(type)) stop("Vector type not found")
	}

	pid <- as.integer(round(runif(1, 1, 1000)))
	cmd <- paste(paste("g.tempfile", .addexe(), sep=""),
                    " pid=", pid, sep="")

	gtmpfl1 <- dirname(ifelse(.Platform$OS.type == "windows", 
		system(cmd, intern=TRUE), system(cmd, 
		intern=TRUE, ignore.stderr=ignore.stderr)))
	rtmpfl1 <- ifelse(.Platform$OS.type == "windows" &&
                (Sys.getenv("OSTYPE") == "cygwin"), 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE), 
		gtmpfl1)

	shname <- substring(vname, 1, ifelse(nchar(vname) > 8, 8, 
		nchar(vname)))

	if (with_prj) E <- " -e"
	else E <- ""
	if (with_c) E <- paste(E, " -c")

	cmd <- paste(paste("v.out.ogr", .addexe(), sep=""),
                " ", E, " input=", vname, " type=", type, 
		" dsn=", gtmpfl1, " olayer=", shname, " format=ESRI_Shapefile", 
		sep="")

	tull <- ifelse(.Platform$OS.type == "windows", system(cmd), 
		system(cmd, ignore.stderr=ignore.stderr))

	res <- readOGR(dsn=rtmpfl1, layer=shname, verbose=!ignore.stderr)

	unlink(paste(rtmpfl1, list.files(rtmpfl1, pattern=shname), 
		sep=.Platform$file.sep))
	if (remove.duplicates && type != "point") {
		dups <- duplicated(slot(res, "data"))
		if (any(dups)) {
			ndata <- as(res, "data.frame")[!dups,,drop=FALSE]
			row.names(ndata) <- ndata$cat
			if (type == "area") {
				pls <- slot(res, "polygons")
			} else if (type == "line") {
				pls <- slot(res, "lines")
			}
			p4s <- proj4string(res)
			IDs <- res$cat
			tab <- table(factor(IDs))
			n <- length(tab)
			if (n + sum(dups) != length(pls))
				stop("length mismatch in duplicate removal")
			IDss <- .mixedsort(names(tab))
			reg <- match(IDs, IDss)
			belongs <- lapply(1:n, function(x) which(x == reg))
			npls <- vector(mode="list", length=n)
			for (i in 1:n) {
				nParts <- length(belongs[[i]])
				srl <- NULL
				for (j in 1:nParts) {
					plij <- pls[[belongs[[i]][j]]]
					if (type == "area") {
						plijp <- slot(plij, "Polygons")
					} else if (type == "line") {
						plijp <- slot(plij, "Lines")
					}
					srl <- c(srl, plijp)
				}
				npls[[i]] <- Polygons(srl, ID=IDss[i])
			}
			SP <- SpatialPolygons(npls, proj4string=CRS(p4s))
			res <- SpatialPolygonsDataFrame(SP, ndata)
		}

	}
	res
}

# Function mixedorder copied from gtools 2.2.3 LGPL Gregory R. Warnes
.mixedsort <- function (x) {
    x[.mixedorder(x)]
}

.mixedorder <- function (x) {
    delim = "\\$\\@\\$"
    numeric <- function(x) {
        optwarn = options("warn")
        on.exit(options(optwarn))
        options(warn = -1)
        as.numeric(x)
    }
    nonnumeric <- function(x) {
        optwarn = options("warn")
        on.exit(options(optwarn))
        options(warn = -1)
        ifelse(is.na(as.numeric(x)), toupper(x), NA)
    }
    x <- as.character(x)
    which.nas <- which(is.na(x))
    which.blanks <- which(x == "")
    if (length(which.blanks) > 0) 
        x[which.blanks] <- -Inf
    if (length(which.nas) > 0) 
        x[which.nas] <- Inf
    delimited <- gsub("([+-]{0,1}[0-9.]+([eE][+-]{0,1}[0-9.]+){0,1})", 
        paste(delim, "\\1", delim, sep = ""), x)
    step1 <- strsplit(delimited, delim)
    step1 <- lapply(step1, function(x) x[x > ""])
    step1.numeric <- lapply(step1, numeric)
    step1.character <- lapply(step1, nonnumeric)
    maxelem <- max(sapply(step1, length))
    step1.numeric.t <- lapply(1:maxelem, function(i) sapply(step1.numeric, 
        function(x) x[i]))
    step1.character.t <- lapply(1:maxelem, function(i) sapply(step1.character, 
        function(x) x[i]))
    rank.numeric <- sapply(step1.numeric.t, rank)
    rank.character <- sapply(step1.character.t, 
	function(x) as.numeric(factor(x)))
    rank.numeric[!is.na(rank.character)] <- 0
    rank.character <- t(t(rank.character) + apply(matrix(rank.numeric), 
        2, max, na.rm = TRUE))
    rank.overall <- ifelse(is.na(rank.character), rank.numeric, 
        rank.character)
    order.frame <- as.data.frame(rank.overall)
    if (length(which.nas) > 0) 
        order.frame[which.nas, ] <- Inf
    retval <- do.call("order", order.frame)
    return(retval)
}

writeVECT6 <- function(SDF, vname, #factor2char = TRUE, 
	v.in.ogr_flags="", ignore.stderr = FALSE) {

	type <- NULL
	if (class(SDF) == "SpatialPointsDataFrame") type <- "point"
	if (class(SDF) == "SpatialLinesDataFrame") type <- "line"
	if (class(SDF) == "SpatialPolygonsDataFrame") type <- "boundary"
	if (is.null(type)) stop("Unknown data class")

	pid <- as.integer(round(runif(1, 1, 1000)))
	cmd <- paste(paste("g.tempfile", .addexe(), sep=""),
                    " pid=", pid, sep="")

	gtmpfl1 <- dirname(ifelse(.Platform$OS.type == "windows", 
		system(cmd, intern=TRUE), system(cmd, 
		intern=TRUE, ignore.stderr=ignore.stderr)))
	rtmpfl1 <- ifelse(.Platform$OS.type == "windows" &&
                (Sys.getenv("OSTYPE") == "cygwin"), 
		system(paste("cygpath -w", gtmpfl1, sep=" "), intern=TRUE), 
		gtmpfl1)

	shname <- substring(vname, 1, ifelse(nchar(vname) > 8, 8, 
		nchar(vname)))

#	switch(type,
##		point = writePointsShape(SDF, paste(rtmpfl1, shname, 
#			sep=.Platform$file.sep), factor2char=factor2char),
#		line = writeLinesShape(SDF, paste(rtmpfl1, shname, 
#			sep=.Platform$file.sep), factor2char=factor2char),
#		boundary = writePolyShape(SDF, paste(rtmpfl1, shname, 
#			sep=.Platform$file.sep), factor2char=factor2char))
#	p4s <- proj4string(SDF)
#	if (!is.na(p4s)) tull <- showWKT(p4s, paste(rtmpfl1, 
#		.Platform$file.sep, shname, ".prj", sep=""))

	writeOGR(SDF, dsn=rtmpfl1, layer=shname, driver="ESRI Shapefile")

	cmd <- paste(paste("v.in.ogr", .addexe(), sep=""),
                    " ", v.in.ogr_flags, " dsn=", gtmpfl1, 
		" output=", vname, " layer=", shname, sep="")

	tull <- ifelse(.Platform$OS.type == "windows", system(cmd), 
		system(cmd, ignore.stderr=ignore.stderr))
	unlink(paste(rtmpfl1, list.files(rtmpfl1, pattern=shname), 
		sep=.Platform$file.sep))

}

vInfo <- function(vname, ignore.stderr = FALSE) {
	cmd <- paste(paste("v.info", .addexe(), sep=""),
                    " map=", vname, sep="")
	if(.Platform$OS.type == "windows") vinfo0 <- system(cmd, intern=TRUE)
	else vinfo0 <- system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)

	m0 <- grep("Number of points", vinfo0)
	m1 <- grep("Number of centroids", vinfo0)
	if (length(m0) == 0 || length(m1) == 0) 
		stop("Vector information not found")

	vinfo1 <- vinfo0[m0:m1]
	vinfo2 <- c(substring(vinfo1, 16, 45), substring(vinfo1, 56, 78))
	con <- textConnection(vinfo2)
	res <- drop(read.dcf(con))
	close(con)
	storage.mode(res) <- "integer"
	res
}

vColumns <- function(vname, ignore.stderr = TRUE) {
	cmd <- paste(paste("v.info", .addexe(), sep=""),
                    " -c map=", vname, sep="")
	if(.Platform$OS.type == "windows") vinfo0 <- system(cmd, intern=TRUE)
	else vinfo0 <- system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)
	con <- textConnection(vinfo0)
	if(.Platform$OS.type == "windows") res <- read.table(con, 
		header=FALSE, sep="|", skip=1)
	else res <- read.table(con, header=FALSE, sep="|")
	close(con)
	names(res) <- c("storageType", "name")
	res
}

vDataCount <- function(vname, ignore.stderr = TRUE) {
	cmd <- paste(paste("v.db.select", .addexe(), sep=""),
                    " -c map=", vname, " column=cat", sep="")
	if(.Platform$OS.type == "windows") tull <- system(cmd, intern=TRUE)
	else tull <- system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)
	n <- length(tull)
	n
}

getSites6 <- function(vname, ignore.stderr = FALSE, with_prj=TRUE) {
# based on suggestions by Miha Staut using v.out.ascii and v.db.select,
# modified to avoid cygwin problems
	SPDF <- getSites6sp(vname, ignore.stderr=ignore.stderr, 
		with_prj=with_prj)
	res <- as(SPDF, "data.frame")
	res
}

getSites6sp <- function(vname, ignore.stderr = FALSE, with_prj=TRUE) {
	res <- readVECT6(vname=vname, ignore.stderr=ignore.stderr, 
		with_prj=with_prj)
	res
}


putSites6 <- function(df, vname, ignore.stderr = FALSE) {
# based on suggestions by Miha Staut using v.out.ascii and v.db.select,
# modified to avoid cygwin problems
	coordinates(df) <- c("x", "y")
	putSites6sp(df, vname, ignore.stderr=ignore.stderr)
}

putSites6sp <- function(SPDF, vname, #factor2char = TRUE, 
	ignore.stderr = FALSE) {
	writeVECT6(SPDF, vname, #factor2char=factor2char, 
		ignore.stderr=ignore.stderr)
}

#Date: Thu, 13 Oct 2005 17:34:06 +0200
#From: Markus Neteler <neteler@itc.it>
#
#EXERCISE: HOW LONG ARE COMMON BOUNDARIES OF POLYGONS?
#
#
## Requires: GRASS 6.1-CVS from 13 Oct 2005 or later
##
## data: sudden infant deaths data from North Carolina
## data imported from SHAPE file with v.in.ogr
#
##let's have a look
# d.mon x0
# d.vect sids
#
##we work on a copy:
# g.copy vect=sids,sids_nc
#
##we add a second layer to the map which references the boundaries of
##polygons. In the vector geometry we generate an ID (category) for each
##boundary:
# v.category sids_nc out=sids_nc2 layer=2 type=boundary option=add
#
##Underlying idea:
##we'll fetch the IDs (categories) of the polygons left and right from
##each boundary and store it into the attribute table linked to layer 2.
##In general:
## cat_of_boundary | cat_of_left_polygon | cat_of_right_polygon | length_of_boundary
##
##We want only one category per boundary, that's why the sides check is
##needed (a boundary may consist of several pieces)
##
##So we create a new attribute table and link it to the new layer 2
##of the vector map:
# v.db.addtable sids_nc2 layer=2 col="left integer,right integer,length integer"
#
##Now we query the polygon/boundary relationsships and store it into
##the attribute table linked to layer 2:
# v.to.db map=sids_nc2 option=sides col=left,right layer=2 
#
##Now we have unique categories for the boundaries and can calculate the
##lengths:
# v.to.db map=sids_nc2 option=length col=length layer=2 
#
##Done.
#
##See the new attribute table containing the boundary lengths:
# v.db.select sids_nc2 layer=2
#
## verification (let's check boundary #193):
# d.vect sids_nc2 cat=193 layer=2 col=red type=boundary
# d.zoom
# d.measure
## LEN:     12756.00 meters
#
##what does the attribute table say:
# v.db.select sids_nc2 layer=2 | grep '^193'
##190|65|68|12814
#
##This is reasonably close since on screen digitization in d.measure
##isn't always that precise ...
#

vect2neigh <- function(vname, ID=NULL, ignore.stderr = FALSE) {

	vinfo <- vInfo(vname)
	types <- names(vinfo)[which(vinfo > 0)]
	if (length(grep("areas", types)) == 0) 
		stop("Vector object not of area type")

	n <- vDataCount(vname, ignore.stderr=ignore.stderr)

	if (!is.null(ID)) {
		if (!is.character(ID)) stop("ID not character string")
		cmd <- paste(paste("v.info", .addexe(), sep=""),
                    " -c ", vname, sep="")
		if(.Platform$OS.type == "windows") 
			tull <- system(cmd, intern=TRUE)
		else tull <- system(cmd, intern=TRUE, 
			ignore.stderr=ignore.stderr)
		if (length(grep(ID, tull)) == 0)
			stop("ID not found")
		cmd <- paste(paste("v.db.select", .addexe(), sep=""),
                    " -c map=", vname, " column=", 
			ID, sep="")
		if(.Platform$OS.type == "windows") 
			ID <- as.character(system(cmd, intern=TRUE))
		else ID <- as.character(system(cmd, intern=TRUE, 
			ignore.stderr=ignore.stderr))
		if (length(unique(ID)) != n) 
			stop("fewer than n unique ID values")
	}
	
	pid <- as.integer(round(runif(1, 1, 1000)))
	vname2 <- paste(vname, pid, sep="")
	cmd <- paste(paste("g.copy", .addexe(), sep=""),
                    " vect=", vname, ",", vname2, sep="")
	if(.Platform$OS.type == "windows") tull <- system(cmd, intern=TRUE)
	else tull <- system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)

	vname2a <- paste(vname2, "a", sep="")
	cmd <- paste(paste("v.category", .addexe(), sep=""),
                    " ", vname2, " out=", vname2a, 
		"  layer=2 type=boundary option=add", sep="")
	if(.Platform$OS.type == "windows") tull <- system(cmd, intern=TRUE)
	else tull <- system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)

	cmd <- paste(paste("v.db.addtable", .addexe(), sep=""),
                    " ", vname2a, 
	" layer=2 col=\"left integer,right integer,length double precision\"", 
	sep="")
	if(.Platform$OS.type == "windows") system(cmd)
	else system(cmd, ignore.stderr=ignore.stderr)

	cmd <- paste(paste("v.to.db", .addexe(), sep=""),
                    " map=", vname2a, 
		" option=sides col=left,right layer=2", sep="")
	if(.Platform$OS.type == "windows") system(cmd)
	else system(cmd, ignore.stderr=ignore.stderr)

	cmd <- paste(paste("v.to.db", .addexe(), sep=""),
                    " map=", vname2a, 
		" option=length col=length layer=2", sep="")
	if(.Platform$OS.type == "windows") system(cmd)
	else system(cmd, ignore.stderr=ignore.stderr)

	cmd <- paste(paste("v.db.select", .addexe(), sep=""),
                    " ", vname2a, " layer=2", sep="")

	if(.Platform$OS.type == "windows") res <- system(cmd, intern=TRUE)
	else res <- system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)

	cmd <- paste(paste("g.remove", .addexe(), sep=""),
                    " vect=", vname2, ",", vname2a, sep="")
	if(.Platform$OS.type == "windows") tull <- system(cmd, intern=TRUE)
	else tull <- system(cmd, intern=TRUE, ignore.stderr=ignore.stderr)

	con <- textConnection(res)
	t2 <- read.table(con, sep="|", header=TRUE, row.names=1)
	close(con)
	t3 <- t2[t2$left == -1,]
	t4 <- tapply(t3$length, t3$right, sum)
	external <- numeric(n)
	external[as.integer(names(t4))] <- t4
	t5 <- t2[!t2$left == -1,]
	tmp <- t5$left
	t5$left <- t5$right
	t5$right <- tmp
	t6 <- rbind(t2, t5)
	total <- c(tapply(t6$length, t6$right, sum))
	res <- t6[!t6$left == -1,]
	res <- aggregate(res[3], by=list(left=res$left, right=res$right), sum)
	res$left <- as.integer(as.character(res$left))
	res$right <- as.integer(as.character(res$right))
	o <- order(res$left, res$right)
	res <- res[o,]
	attr(res, "external") <- external
	attr(res, "total") <- total
	attr(res, "region.id") <- ID
	attr(res, "n") <- n
	class(res) <- c(class(res), "GRASSneigh", "spatial.neighbour")

	res
}



