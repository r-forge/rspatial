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

# readCELL6 <- function(vname, cat=FALSE) {
# 	tmpfl <- tempfile()
# 	system(paste("r.out.arc input=", vname, " output=", tmpfl, sep=""))
# 	library(rgdal)
# 	hdl <- GDAL.open(tmpfl)
# 	dims <- dim(hdl)
# 	res <- getRasterTable(hdl)
# 	GDAL.close(hdl)
# 	if (cat) {
# 		cats <- strsplit(system(paste("r.stats -l", vname), 
# 			intern=TRUE), " ")
# 		catnos <- sapply(cats, function(x) x[1])
# 		catlabs <- sapply(cats, function(x) paste(x[-1], collapse=" "))
# 		if (any(!is.na(match(catnos, "*")))) {
# 			isNA <- which(catnos == "*")
# 			catnos <- catnos[-isNA]
# 			catlabs <- catlabs[-isNA]
# 		}
# 		res[,3] <- factor(res[,3], levels=catnos, labels=catlabs)
# 	} else {
# 		res[,3] <- as.integer(res[,3])
# 	}
# 	colnames(res) <- c("north", "east", vname)
# 	attr(res, "hdl_dims") <- dims
# 	res
# }

# readFLOAT6 <- function(vname) {
# 	tmpfl <- tempfile()
# 	system(paste("r.out.arc input=", vname, " output=", tmpfl, sep=""))
# 	library(rgdal)
# 	hdl <- GDAL.open(tmpfl)
# 	dims <- dim(hdl)
# 	res <- getRasterTable(hdl)
# 	GDAL.close(hdl)
# 	res[,3] <- as.double(res[,3])
# 	colnames(res) <- c("north", "east", vname)
# 	attr(res, "hdl_dims") <- dims
# 	res
# }


readCELL6sp <- function(vname, cat=FALSE) {
	tmpfl <- tempfile()
	system(paste("r.out.arc input=", vname, " output=", tmpfl, sep=""))
	library(sp)
	p4 <- CRS(system("g.proj -j -f", intern=TRUE))
	res <- read.asciigrid(tmpfl, colname=vname, proj4string=p4)
	if (cat) {
		cats <- strsplit(system(paste("r.stats -l -q", vname), 
			intern=TRUE), " ")
		catnos <- sapply(cats, function(x) x[1])
		catlabs <- sapply(cats, function(x) paste(x[-1], collapse=" "))
		if (any(!is.na(match(catnos, "*")))) {
			isNA <- which(catnos == "*")
			catnos <- catnos[-isNA]
			catlabs <- catlabs[-isNA]
		}
		res@data[[1]] <- factor(res@data[[1]], levels=catnos, labels=catlabs)
	} else {
		res@data[[1]] <- as.integer(res@data[[1]])
	}
	res
}

readFLOAT6sp <- function(vname) {
	tmpfl <- tempfile()
	system(paste("r.out.arc input=", vname, " output=", tmpfl, sep=""))
	library(sp)
	p4 <- CRS(system("g.proj -j -f", intern=TRUE))
	res <- read.asciigrid(tmpfl, colname=vname, proj4string=p4)
	res
}


writeRast6sp <- function(x, vname, zcol = 1, NODATA=-9999) {
	if (!is.numeric(x@data[[zcol]])) 
		stop("only numeric columns may be exported")
	tmpfl <- tempfile()
	library(sp)
	write.asciigrid(x, tmpfl, attr = zcol, na.value = NODATA)
	system(paste("r.in.gdal -o input=", tmpfl, " output=", vname, sep=""))
}


# writeRast6 <- function(df, vname, zcol = 3, xcol = 1, ycol = 2, NODATA=-9999,
#    tol=1e-8) {
# 	if (!is.numeric(df[,zcol])) stop("only numeric columns may be exported")
# 	tmpfl <- tempfile()
# 	arcGrid(df, tmpfl, zcol=zcol, xcol=xcol, ycol=ycol, NODATA=NODATA,
# 		tol=tol)
# 	system(paste("r.in.gdal -o input=", tmpfl, " output=", vname, sep=""))
# }

# arcGrid <- function (xyz, file, zcol = 3, xcol = 1, ycol = 2, NODATA=-9999,
#    tol=1e-8) 
# original code by Edzer Pebesma
# {
#    if (ncol(xyz) < 3) 
#       stop("xyz object should have at least three columns")
#  z = xyz[, zcol]
#     z[!is.finite(z)] <- NODATA
#     x = xyz[, xcol]
#     y = xyz[, ycol]
#     xx = sort(unique(x))
#     yy = sort(unique(y))
#     my = match(y, yy)
#     nx = length(xx)
#     ny = length(yy)
#     nmax = max(nx, ny)
#     difx = diff(xx)
#     if (diff(range(unique(difx))) > tol) 
#         stop("x intervals are not constant")
#     dify = diff(yy)
#     if (diff(range(unique(dify))) > tol) 
#         stop("y intervals are not constant")
#     dx = difx[1]
#     dy = dify[1]
#     ratio = (nx * dx)/(ny * dy)
#     xmin = min(xx)
#     xmax = max(xx)
#     xrange = xmax - xmin
#     ymin = min(yy)
#     ymax = max(yy)
#     yrange = ymax - ymin
#     zzz <- file(file, "w")
#     cat("NCOLS ", nx, "\n", file=zzz)
#     cat("NROWS ", ny, "\n", file=zzz)
#     cat("XLLCENTER ", xmin, "\n", file=zzz)
#     cat("YLLCENTER ", ymin, "\n", file=zzz)
#     cat("CELLSIZE" , dx, "\n", file=zzz)
#     cat("NODATA_VALUE" , NODATA, "\n", file=zzz)
#     for(i in ny:1) {
# 	zz <- rep(NODATA, nx)
# 	mmy <- which(my == i)
# 	zz[match(x[mmy], xx)] <- z[mmy]
#        write(zz, file=zzz, ncolumns=nx, append=TRUE)
#     }
#     close(zzz)
# }

