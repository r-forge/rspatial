setClass("SpatialGridded", 
	representation("Spatial", 
		cellcentre.offset = "numeric",
		cellsize = "numeric",
		cells.dim = "integer"),
	prototype = list( # not so relevant what this does
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)), 
		cellcentre.offset = numeric(0),
		cellsize = numeric(0), 
		cells.dim = integer(0)),
	validity = function(object) {
		n = dimensions(object)
		if (length(na.omit(object@cellcentre.offset)) != n)
			return("cellcentre.offset has incorrect dimension")
		if (length(na.omit(object@cellsize)) != n)
			return("cellsize has incorrect dimension")
		if (sum(object@cells.dim > 0) != n)
			return("cells.dim has incorrect dimension")
		return(TRUE)
	}
)

SpatialGridded = function(cellcentre.offset, cellsize, cells.dim,
		crs = CRS(as.character(NA)), cell.extent = 0.5) {
	min = cellcentre.offset - cell.extent * cellsize
	max = cellcentre.offset + (cells.dim + cell.extent) * cellsize
	bbox = cbind(min, max)
	dimnames(bbox) = list(NULL, c("min","max"))
	new("SpatialGridded",
		bbox = bbox,
		proj4string = crs,
		cellcentre.offset = cellcentre.offset,
		cellsize = cellsize,
		cells.dim = as.integer(cells.dim))
}

coordinatevalues = function(obj) {
	if (!is(obj, "SpatialGridded"))
		stop("function only works for objects of class or extending SpatialGridded")
	args = list()
	for (i in seq(along=obj@cells.dim)) {
		if (i == 2) # y-axis is the exception--starting at top of map, and decreasing:
			args[[i]] = obj@cellcentre.offset[i] + 
				obj@cellsize[i] * ((obj@cells.dim[i] - 1):0)
		else
			args[[i]] = obj@cellcentre.offset[i] + 
				obj@cellsize[i] * (0:(obj@cells.dim[i] - 1))
	}
	names(args) = dimnames(obj@bbox)[[1]]
	args
}

setMethod("coordinates", "SpatialGridded", function(obj) {
	cc = do.call("expand.grid", coordinatevalues(obj))
	as.matrix(sapply(cc, as.numeric))
})

points2grid = function(points, tolerance) {
	# work out grid topology from points
	n = dimensions(points)
	ret = new("SpatialGridded", as(points, "Spatial"),
		cellcentre.offset = numeric(n),
		cellsize = numeric(n),
		cells.dim = as.integer(rep(1,n)))
	cc = coordinates(points)
	for (i in 1:n) { # loop over x, y, and possibly z
		x = cc[, i]
    	xx = sort(unique(x))
    	difx = diff(xx)
    	if (diff(range(unique(difx))) > tolerance)
       		stop(paste("dimension", i,": coordinate intervals are not constant"))
		ret@cellsize[i] = mean(difx)
		ret@cellcentre.offset[i] = min(xx)
    	ret@cells.dim[i] = length(xx)
	}
	nm = dimnames(cc)[[2]]
	names(ret@cellsize) = nm
	names(ret@cellcentre.offset) = nm
	names(ret@cells.dim) = nm
	ret
}

.NumberOfCells = function(x) {
	if (!is(x, "SpatialGridded"))
		stop(".NumberOfCells only works on objects of class SpatialGridded")
	cd = x@cells.dim
	n = cd[1]
	for (i in 2:length(cd))
		n = n * cd[i]
	n
}

gridparameters = function(obj) { 
	if (is(obj, "SpatialGridded"))
		return(data.frame( 
			cellcentre.offset= obj@cellcentre.offset,
			cellsize = obj@cellsize,
			cells.dim = obj@cells.dim))
	if (is(obj, "SpatialCell"))
		return(gridparameters(obj@grid))
	return(numeric(0))
}

print.SpatialGridded = function(x, ...) {
	res = data.frame(rbind(x@cellcentre.offset, x@cellsize, as.numeric(x@cells.dim)))
	rownames(res) = c("cellcentre.offset", "cellsize", "cells.dim")
	print(res)
	invisible(res)
}

summary.SpatialGridded = function(object, ...) {
	ret = list()
	ret[["values"]] = gridparameters(object)
	class(ret) = "summary.SpatialGridded"
	ret
}

print.summary.SpatialGridded = function(x, ...) {
	cat("Grid parameters:\n")
	print(x$values)
	invisible(x)
}

setMethod("show", "SpatialGridded", function(object) summary(obj))

print.SpatialCell = function(x, ...) {
	cat("Object of class SpatialCell\n")
	print(as(x, "SpatialGridded"))
	print(as(x, "SpatialPoints"))
	invisible(x)
}
