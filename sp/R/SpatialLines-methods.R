Sline <- function(coords, proj4string=CRS(as.character(NA))) {
	if (!is.matrix(coords)) coords <- as.matrix(coords)
	if (mode(coords) != "numeric")
		stop("coordinates should have mode numeric")
	bbox <- .bboxSlot(coords)
	new("Sline", coords = coords, bbox = as.matrix(bbox),
		proj4string = proj4string)
}

Slines <- function(slinelist) {
	if (is(slinelist, "Sline"))
		slinelist = list(slinelist)
	if (any(sapply(slinelist, function(x) !is(x, "Sline"))))
		stop("slinelist not a list of Sline objects")
	projargs <- unique(sapply(slinelist, proj4string))
	if (length(projargs) > 1) 
		stop("differing projections among Sline objects")
	Sp <- new("Spatial", bbox= .bboxSls(slinelist), proj4string=CRS(projargs))
	new("Slines", Sp, Slines = slinelist)
}

SpatialLines <- function(SlineList) {
	if (any(sapply(SlineList, function(x) !is(x, "Slines")))) 
		stop("polygons not Slines objects")
	if (length(unique(sapply(SlineList, function(x) proj4string(x)))) != 1) 
		stop("Different projections in list of Sline objects")
	Sp <- new("Spatial", bbox = .bboxSls(SlineList), 
		proj4string=CRS(proj4string(SlineList[[1]])))
	res <- new("SpatialLines", Sp, lines=SlineList)
	res
}

.bboxSls <- function(lst) {
	x <- sapply(lst, function(x) bbox(x)[1,])
	y <- sapply(lst, function(x) bbox(x)[2,])
	r1 <- range(x)
	r2 <- range(y)
	res <- rbind(r1, r2)
	colnames(res) <- c("min", "max")
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
	SlineList <- arcobj2SlineList(arc, proj4string=proj4string)
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

shapes2SlineList <- function(shapes, proj4string=CRS(as.character(NA))) {
	if (attr(shapes, "shp.type") != "arc")
		stop("Not arc shapes")
	if (any(sapply(shapes, function(x) attr(x, "nParts"))) != 1)
		stop("only simple line shapes permitted")
	n <- length(shapes)
	res <- vector(mode="list", length=n)
	for (i in 1:n) {
		crds <- shapes[[i]]$verts
		res[[i]] <- Sline(coords=crds, proj4string=proj4string)
	}
	res
}

shapes2SpatialLines <- function(shapes, proj4string=CRS(as.character(NA))) {
	SlineList <- shapes2SlineList(shapes, proj4string=proj4string)
	res <- SpatialLines(SlineList)
	res
}

shp2SLDF <- function(shp, proj4string=CRS(as.character(NA))) {
	df <- shp$att.data
	SL <- shp2SpatialLines(shp$Shapes, proj4string=proj4string)
	res <- SLDF(SL, df=df)
	res
}

plotSpatialLines <- function(SL, xlim = bbox(SL)[1,], ylim = bbox(SL)[2,], asp = 1, col = 1, ...) 
{
	frame()
	plot.window(xlim = xlim, ylim = ylim, asp = asp)
	lst <- SL@lines
	for (i in seq(along=lst)) {
		sllst = lst[[i]]@Slines
		for (j in seq(along=sllst)) {
			crds <- coordinates(sllst[[j]])
			if (length(col) == length(lst))
				lines(crds, col = col[i], ...)
			else
				lines(crds, col = col[1], ...)
		}
	}
}

summary.SpatialLines = summary.Spatial

plot.SpatialLines = function(x, ...) plotSpatialLines(x, ...)

setMethod("coordinates", "Sline", function(obj) obj@coords)

setMethod("coordinates", "Slines", function(obj) lapply(obj@Slines, coordinates))

setMethod("coordinates", "SpatialLines", function(obj) lapply(obj@lines, coordinates))
