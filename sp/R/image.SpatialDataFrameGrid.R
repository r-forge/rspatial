# first argument of image generic _needs_ to be x!
image.SpatialDataFrameGrid = function(x, attr = 1, xcol = 1, ycol = 2, 
		asp = 1, ...) {
    image.default(as.image.SDFG(data = x, attr = attr, x = xcol, y = ycol), 
		asp = asp, ...)
}

as.image.SDFG = function(data, attr = 1, xcol = 1, ycol = 2) {
	if (!is(data, "SpatialDataFrameGrid"))
		stop("obj should be of class SpatialDataFrameGrid")
	if (min(xcol,ycol) < 1 || max(xcol,ycol) > 3 || xcol == ycol)
		stop("xcol and ycol should be in 1, 2 or 3 and be distinct")
	x = xcol
	y = ycol
    xmin = data@cellcentre.offset[x]
    xmax = xmin + (data@cells.dim[x] - 1) * data@cellsize[x]
    ymin = data@cellcentre.offset[y]
    ymax = ymin + (data@cells.dim[y] - 1) * data@cellsize[y]
    xx = seq(xmin, xmax, data@cellsize[x])
    yy = seq(ymin, ymax, data@cellsize[y])
	cc = coordinates(data)
    row = round((cc[,x] - data@cellcentre.offset[x])/data@cellsize[x]) + 1
    col = round((cc[,y] - data@cellcentre.offset[y])/data@cellsize[y]) + 1
	# zz = rep(NA, data@cells.dim[x] * data@cells.dim[y])
	# zz[index] = data@data[,-data@coord.columns][,attr]
	if (is.character(attr))
		z = data@data[,attr]
	else { 
		z = data@data[ , -data@coord.columns, drop = FALSE]
		if (NCOL(z) >= 1)
			z = z[, attr, drop = TRUE]
		else # no attributes present; show zeroes:
			z = rep(0, NROW(z))
	}
	zz = as.numeric(rep(NA, data@cells.dim[x] * data@cells.dim[y]))
	zz[(col - 1) * data@cells.dim[x] + row] = z
    list(x = xx, y = yy, z = 
		 matrix(zz, nrow = data@cells.dim[x], ncol = data@cells.dim[y]))
}
