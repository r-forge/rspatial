Sline <- function(coords, proj4string=CRS(as.character(NA))) {
	if (!is.matrix(coords)) coords <- as.matrix(coords)
	if (mode(coords) != "numeric")
		stop("coordinates should have mode numeric")
	bbox <- .bboxSlot(coords)
	new("Sline", coords = coords, bbox = as.matrix(bbox),
		proj4string = proj4string)
}

SpatialLines <- function(SlineList) {
	if (any(sapply(SlineList, function(x) !is(x, "Sline")))) 
		stop("polygons not Sline objects")
	if (length(unique(sapply(SlineList, function(x) proj4string(x)))) != 1) 
		stop("Different projections in list of Sline objects")
	projargs <- proj4string(SlineList[[1]])
	bbox <- .bboxR4s(SlineList)
	Sp <- new("Spatial", bbox=bbox, proj4string=CRS(projargs))
	res <- new("SpatialLines", Sp, lines=SlineList)
	res
}

SLDF <- function(SL, df) {
	res <- new("SpatialLinesDataFrame", SL, data=df)
	res
}

contourLines2SlineList <- function(cL, proj4string=CRS(as.character(NA))) {
	n <- length(cL)
	res <- vector(mode="list", length=n)
	for (i in 1:n) {
		crds <- cbind(cL[[i]][[2]], cL[[i]][[3]])
		res[[i]] <- Sline(coords=crds, proj4string=proj4string)
	}
	res
}

contourLines2df <- function(cL) {
	var <- sapply(cL, function(x) x[[1]])
	res <- data.frame(level=var)
	res
}

contourLines2SpatialLines <- function(cL, proj4string=CRS(as.character(NA))) {
	SlineList <- contourLines2SlineList(cL, proj4string=proj4string)
	res <- SpatialLines(SlineList)
	res
}

contourLines2SLDF <- function(cL, proj4string=CRS(as.character(NA))) {
	df <- contourLines2df(cL)
	SL <- contourLines2SpatialLines(cL, proj4string=proj4string)
	res <- SLDF(SL, df=df)
	res
}

arcobj2SlineList <- function(arc, proj4string=CRS(as.character(NA))) {
	n <- length(arc[[2]])
	res <- vector(mode="list", length=n)
	for (i in 1:n) {
		crds <- cbind(arc[[2]][[i]][[1]], arc[[2]][[i]][[2]])
		res[[i]] <- Sline(coords=crds, proj4string=proj4string)
	}
	res
}

arcobj2SpatialLines <- function(arc, proj4string=CRS(as.character(NA))) {
	SlineList <- arcobj2SlineList(arc[[2]], proj4string=proj4string)
	res <- SpatialLines(SlineList)
	res
}

arcobj2df <- function(arc) {
	res <- data.frame(arc[[1]])
	res
}

arcobj2SLDF <- function(arc, proj4string=CRS(as.character(NA))) {
	df <- arcobj2df(arc)
	SL <- arcobj2SpatialLines(arc, proj4string=proj4string)
	res <- SLDF(SL, df=df)
	res
}

plotSpatialLines <- function(SL) {
	xr <- bbox(SL)[1,]
	yr <- bbox(SL)[2,]
	frame()
	plot.window(xlim=xr, ylim=yr, asp=1)
	lst <- getSLlinesSlot(SL)
	for (i in 1:length(lst)) {
		crds <- getSlineCoordsSlot(lst[[i]])
		lines(crds)
	}
}

