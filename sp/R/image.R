# first argument of image generic _needs_ to be x!
image.SpatialCellDataFrame = function(x, attr = 1, xcol = 1, ycol = 2, 
		asp = 1, xlab, ylab, ...)
    image.SpatialGriddedDataFrame(as(x, "SpatialGriddedDataFrame"), 
		attr = attr, xcol = xcol, ycol = ycol, asp = asp, ...)

image.SpatialGriddedDataFrame = function(x, attr = 1, xcol = 1, ycol = 2, 
		asp = 1, xlab, ylab, ...) {
	cnames = dimnames(coordinates(x))[[2]]
	if (missing(xlab))
		xlab = cnames[xcol]
	if (missing(ylab))
		ylab = cnames[ycol]
	image(as.image.SpatialGriddedDataFrame(x, attr, xcol, ycol), 
		asp = asp, xlab = xlab, ylab = ylab, ...)
}

as.image.SpatialGriddedDataFrame = function(x, attr = 1, xcol = 1, ycol = 2) {
	m = as.matrix(x[attr])
	cv = coordinatevalues(x)
	m = as.matrix(x)
	list(x = cv[[xcol]], y = sort(cv[[ycol]]), z = m[,ncol(m):1])
}
