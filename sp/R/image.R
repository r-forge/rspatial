# first argument of image generic _needs_ to be x!
image.SpatialCellDataFrame = function(x, attr = 1, xcol = 1, ycol = 2, 
		asp = 1, ...) {
    image.default(as.image.SpatialCellDataFrame(data = x, attr = attr, x = xcol, 
		y = ycol), asp = asp, ...)
}

as.image.SpatialCellDataFrame = function(data, attr = 1, xcol = 1, ycol = 2) {
	if (!is(data, "SpatialCellDataFrame"))
		stop("obj should be of class SpatialCellDataFrame")
	if (min(xcol,ycol) < 1 || max(xcol,ycol) > 3 || xcol == ycol)
		stop("xcol and ycol should be in 1, 2 or 3 and be distinct")
	x = xcol
	y = ycol
	grid = data@grid
    xmin = grid@cellcentre.offset[x]
    xmax = xmin + (grid@cells.dim[x] - 1) * grid@cellsize[x]
    ymin = grid@cellcentre.offset[y]
    ymax = ymin + (grid@cells.dim[y] - 1) * grid@cellsize[y]
    xx = seq(xmin, xmax, grid@cellsize[x])
    yy = seq(ymin, ymax, grid@cellsize[y])
	cc = coordinates(data)
    row = round((cc[,x] - grid@cellcentre.offset[x])/grid@cellsize[x]) + 1
    col = round((cc[,y] - grid@cellcentre.offset[y])/grid@cellsize[y]) + 1
	# zz = rep(NA, data@cells.dim[x] * data@cells.dim[y])
	# zz[index] = data@data[,-data@coord.columns][,attr]
	if (is.character(attr) || is.numeric(attr))
		z = data@data[,attr]
	else { 
		# z = data@data[ , -data@coord.columns, drop = FALSE]
		if (NCOL(z) >= 1)
			z = z[, attr, drop = TRUE]
		else # no attributes present; show zeroes:
			z = rep(0, NROW(z))
	}
	zz = as.numeric(rep(NA, grid@cells.dim[x] * grid@cells.dim[y]))
	zz[(col - 1) * grid@cells.dim[x] + row] = z
    list(x = xx, y = yy, z = 
		 matrix(zz, nrow = grid@cells.dim[x], ncol = grid@cells.dim[y]))
}
