
setClass("SpatialDataFramePolygons",
	representation("SpatialDataFrame",
		polygons = "Polylist4",
		has.holes = "logical"),
#	prototype = list(data = data.frame(),
#		polygons = as.list(NULL), has.holes = FALSE),
	validity = function(object) {
		if (nrow(object@data) != length(object@polygons@polygons))
			return("number of rows in data should equal number of polygons")
		valid = as.logical(sapply(object@polygons@polygons, verifyPolygon))
		if (any(!valid))
			return(paste("invalid polygon(s):", paste(which(!valid), 
				collapse = " ")))
		# perform more checks here?
		# check for holes, islands or all kinds of trouble?
		return(TRUE)
	}
)

summary.SpatialDataFramePolygons = summary.SpatialData

"Polygons<-" = function(obj, value) {
	if (!is.null(obj) && !is(obj, "SpatialDataFrame"))
		stop("obj is not a SpatialDataFrame")
	if (any(x <- !as.logical(sapply(value@polygons, verifyPolygon))))
		stop(paste("polygon(s)", paste(which(x), collapse = " "), "not valid"))
	rangePolygons = function(x) as.vector(apply(x@coords, 2, range))
	r = t(sapply(value@polygons, rangePolygons))
	bbox = matrix(NA, 2, 2)
	bbox[1,1] = min(r[,1], na.rm=TRUE)
	bbox[1,2] = max(r[,2], na.rm=TRUE)
	bbox[2,1] = min(r[,3], na.rm=TRUE)
	bbox[2,2] = max(r[,4], na.rm=TRUE)
	dimnames(bbox)[[2]] = c("min", "max")
	# if (is.null(obj))
	#	obj = getMeanDF(value@polygons)
	# verify has.holes thing, how do we provide this?
	new("SpatialDataFramePolygons", 
		bbox = bbox,
		proj4string = CRS(as.character(NA)), 
		data = obj@data,
		coord.names = obj@coord.names,
		coord.columns = obj@coord.columns,
		polygons = value,
		has.holes = FALSE)
}

Polygons = function(obj) { 
	if (!(is(obj, "SpatialDataFramePolygons")))
		stop("polygons function only available for SpatialDataPolygons objects")
	obj@polygons
}

SpatialDataFramePolygons = function(SDF, polygons) {
	Polygons(SDF) = polygons 
	SDF
}

plot.SpatialDataFramePolygons = function(x, attr=NULL, breaks=NULL, col=NA, asp = 1, xlab=x@coord.names[1], ylab=x@coord.names[2], add=FALSE, xlim=NULL, ylim=NULL, border=par("fg"), xpd=NULL, density=NULL, angle=45, ...) {
	if (is.null(attr)) {
		plot.Polylist4(x@polygons, col=col, border=border, asp=asp, 
			xlab=xlab, ylab=ylab, add=add, xlim=xlim, 
			ylim=ylim, xpd=xpd, ...) 
	} else { 
		if (is.character(attr))
			z = x@data[,attr]
		else { 
			z = x@data[, -x@coord.columns]
			if (NCOL(z) > 1)
			z = z[, attr]
			if (NCOL(z) == 0) # no attributes present
				z = rep(NA, NROW(z))
		}
		if (is.factor(z)) {
			if (missing(col)) {
				if (length(density) != nlevels(z))
					stop("Number of densities differs from number of factor levels")
				if (length(density) != length(angle))
					angle <- rep(angle, length.out=length(density))
				density <- density[as.integer(z)]
				angle <- angle[as.integer(z)]
				mCols <- NA
			} else {
				if (length(col) != nlevels(z))
					stop("Number of colours differs from number of factor levels")
				mCols <- col[as.integer(z)]
			}
		} else {
			if (is.null(breaks))
				stop("breaks must be given")
			if (missing(col)) {
				if (length(density) != (length(breaks)-1))
					stop("Number of densities not one less than number of breaks")
				if (length(density) != length(angle))
					angle <- rep(angle, length.out=length(density))
				density <- density[findInterval(z, breaks, 
					all.inside=TRUE)]
				angle <- angle[findInterval(z, breaks, 
					all.inside=TRUE)]
				mCols <- NA
			} else {
				if (length(col) != (length(breaks)-1))
					stop("Number of colours not one less than number of breaks")
				mCols <- col[findInterval(z, breaks, 
					all.inside=TRUE)]
			}
		}
		plot.Polylist4(x@polygons, col=mCols, border=border, asp=asp, 
			xlab=xlab, ylab=ylab, add=add, xlim=xlim, 
			ylim=ylim, xpd=xpd, density=density, angle=angle, ...) 
	}
}

cbindSDFP <- function(SDFP, DF) {
	if (nrow(SDFP@data) != nrow(DF))
		stop("Different numbers of rows")
	data <- data.frame(as(SDFP@data, "data.frame"), DF)
	coordinates(data) <- SDFP@coord.names
	Polygons(data) <- Polygons(SDFP)
	data
}
