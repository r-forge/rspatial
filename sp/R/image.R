# first argument of image generic _needs_ to be x!
image.SpatialPixelsDataFrame = function(x, ...)
	image(as(x, "SpatialGridDataFrame"), ...)

image.SpatialGridDataFrame = function(x, attr = 1, xcol = 1, ycol = 2, 
		red=NULL, green=NULL, blue=NULL, asp = 1, axes = FALSE, ...) {
	if (is.null(red)) image(as.image.SpatialGridDataFrame(x[attr], 
		xcol, ycol), asp = asp, axes = axes, ...)
	else {
		if (is.null(green) || is.null(blue)) 
			stop("all colour bands must be given")
		fcols <- factor(rgb(red=x@data[red][[1]], 
			green=x@data[green][[1]], 
			blue=x@data[blue][[1]], max=255))
		cv <- coordinatevalues(getGridTopology(x))
		m <- matrix(as.integer(fcols), x@grid@cells.dim[1], 
			x@grid@cells.dim[2], byrow=FALSE)
		res <- list(x=cv[[xcol]], y=sort(cv[[ycol]]), z=m[,ncol(m):1])
		image(res, col=levels(fcols), asp = asp, axes = axes, ...)
	}
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
