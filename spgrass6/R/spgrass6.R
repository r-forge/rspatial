# Interpreted GRASS 6 interface functions
# Copyright (c) 2005 Roger S. Bivand
#

gmeta6 <- function() {
	tmpfl <- tempfile()
	system(paste("g.region -p3 >", tmpfl))
	res <- read.dcf(tmpfl)
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
	lres$proj4 <- system("g.proj -j -f", intern=TRUE)
	gisenv <- gsub("[';]", "", system("g.gisenv", intern=TRUE))
	gisenv <- strsplit(gisenv, "=")
	glist <- as.list(sapply(gisenv, function(x) x[2]))
	names(glist) <- sapply(gisenv, function(x) x[1])
	lres <- c(glist, lres)
	lres
}

getSites6 <- function(vname) {
# based on suggestions by Miha Staut
	tmpfl1 <- tempfile()
	system(paste("v.out.ascii in=", vname, " out=", tmpfl1, sep=""))
	res1 <- read.table(tmpfl1, sep="|", header=FALSE)
	names(res1) <- c("x", "y", ifelse(ncol(res1) == 3, "cat", 
		c("z", "cat")))
	tmpfl2 <- tempfile()
	system(paste("v.db.select map=", vname, " > ", tmpfl2, sep=""))
	res2 <- read.table(tmpfl2, sep="|", header=TRUE)
	res <- merge(res1, res2, sort=FALSE)
	res
}


putSites6 <- function(df, vname) {
	tmpfl1 <- tempfile()
	write.table(df, tmpfl1, sep="|", quote=FALSE, row.names = FALSE, 
		col.names = FALSE)
	ndf <- names(df)
	ndf1 <- gsub("\\.", "_", ndf)
	cmd <- paste("v.in.ascii in=", tmpfl1, " out=", vname, sep="")
	cmd <- paste(cmd, " x=", which(ndf == "x"), sep="")
	cmd <- paste(cmd, " y=", which(ndf == "y"), sep="")
	cmd <- paste(cmd, " cat=", which(ndf == "cat"), sep="")
	ncl <- sapply(df, class)
	cols <- "columns='"
	for (i in 1:length(ndf1)) {
		if (ncl[i] == "integer") {
			cols <- paste(cols, ndf1[i], "int")
		} else if (ncl[i] == "numeric") {
			cols <- paste(cols, ndf1[i], "double")
		} else if (ncl[i] == "factor") {
			val <- max(nchar(levels(df[,i])))
			cols <- paste(cols, " ", ndf1[i], " varchar(", 
				val, ")", sep="")
		} else if (ncl[i] == "character") {
			val <- max(nchar(df[,i]))
			cols <- paste(cols, " ", ndf1[i], " varchar(", 
				val, ")", sep="")
		} else stop(paste("class", ncl[i], "cannot be exported"))
		if (i < length(ndf1)) cols <- paste(cols, ",", sep="")
		else cols <- paste(cols, "'", sep="")
	}
	cmd <- paste(cmd, cols)
	system(cmd)
	cmd
}

readCELL6 <- function(vname, cat=FALSE) {
	tmpfl <- tempfile()
	system(paste("r.out.arc input=", vname, " output=", tmpfl, sep=""))
	library(rgdal)
	hdl <- GDAL.open(tmpfl)
	dims <- dim(hdl)
	res <- getRasterTable(hdl)
	GDAL.close(hdl)
	if (cat) {
		cats <- strsplit(system(paste("r.stats -l", vname), 
			intern=TRUE), " ")
		catnos <- sapply(cats, function(x) x[1])
		catlabs <- sapply(cats, function(x) paste(x[-1], collapse=" "))
		if (any(!is.na(match(catnos, "*")))) {
			isNA <- which(catnos == "*")
			catnos <- catnos[-isNA]
			catlabs <- catlabs[-isNA]
		}
		res[,3] <- factor(res[,3], levels=catnos, labels=catlabs)
	} else {
		res[,3] <- as.integer(res[,3])
	}
	colnames(res) <- c("north", "east", vname)
	attr(res, "hdl_dims") <- dims
	res
}

readFLOAT6 <- function(vname) {
	tmpfl <- tempfile()
	system(paste("r.out.arc input=", vname, " output=", tmpfl, sep=""))
	library(rgdal)
	hdl <- GDAL.open(tmpfl)
	dims <- dim(hdl)
	res <- getRasterTable(hdl)
	GDAL.close(hdl)
	res[,3] <- as.double(res[,3])
	colnames(res) <- c("north", "east", vname)
	attr(res, "hdl_dims") <- dims
	res
}

writeCELL6 <- function(var, vname) {

}

writeFLOAT6 <- function(var, vname) {

}

