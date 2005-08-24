# first argument of image generic _needs_ to be x!
image.SpatialPixelsDataFrame = function(x, ...)
	image(as(x, "SpatialGridDataFrame"), ...)

image.SpatialGridDataFrame = function(x, attr = 1, xcol = 1, ycol = 2, 
		asp = 1, axes = FALSE, ...) {
	image(as.image.SpatialGridDataFrame(x[attr], xcol, ycol), 
		asp = asp, axes = axes, ...)
	if (axes) {
		axis(3, labels = FALSE)
		axis(4, labels = FALSE)
	}
}

as.image.SpatialGridDataFrame = function(x, xcol = 1, ycol = 2) {
	cv = coordinatevalues(getGridTopology(x))
	m = as(x, "matrix")
	list(x = cv[[xcol]], y = sort(cv[[ycol]]), z = m[,ncol(m):1])
}
