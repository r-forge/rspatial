GridTopology = function(cellcentre.offset, cellsize, cells.dim, crs =
		CRS(as.character(NA)), cell.extent = 0.5) {
	#bb = cbind(cellcentre.offset - cell.extent * cellsize, 
	#	cellcentre.offset + (cells.dim + cell.extent) * cellsize)
	new("GridTopology",
		cellcentre.offset = cellcentre.offset,
		cellsize = cellsize,
		cells.dim = as.integer(cells.dim))
}

setMethod("show", "GridTopology", function(object) summary(obj))

setMethod("coordinates", "GridTopology", function(obj) {
	cc = do.call("expand.grid", coordinatevalues(obj))
	as.matrix(sapply(cc, as.numeric))
})

coordinatevalues = function(obj) {
	if (!is(obj, "GridTopology"))
		stop("function only works for objects of class or extending GridTopology")
	ret = list()
	for (i in seq(along=obj@cells.dim)) {
		if (i == 2) # y-axis is the exception--starting at top of map, and decreasing:
			ret[[i]] = obj@cellcentre.offset[i] + 
				obj@cellsize[i] * ((obj@cells.dim[i] - 1):0)
		else
			ret[[i]] = obj@cellcentre.offset[i] + 
				obj@cellsize[i] * (0:(obj@cells.dim[i] - 1))
	}
	ns = names(obj@cellcentre.offset)
	if (is.null(ns))
		ns = paste("s", 1:length(ret), sep = "") #dimnames(obj@bbox)[[1]]
	names(ret) = ns
	ret
}

points2grid = function(points, tolerance) {
	# work out grid topology from points
	n = dimensions(points)
	ret = new("GridTopology", 
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
	if (!is(x, "GridTopology"))
		stop(".NumberOfCells only works on objects of class GridTopology")
	cd = x@cells.dim
	n = cd[1]
	for (i in 2:length(cd))
		n = n * cd[i]
	n
}

print.GridTopology = function(x, ...) {
	res = data.frame(rbind(x@cellcentre.offset, x@cellsize, as.numeric(x@cells.dim)))
	rownames(res) = c("cellcentre.offset", "cellsize", "cells.dim")
	print(res)
	invisible(res)
}

summary.GridTopology = function(object, ...) {
	ret = list()
	ret[["values"]] = gridparameters(object)
	class(ret) = "summary.GridTopology"
	ret
}

print.summary.GridTopology = function(x, ...) {
	cat("Grid topology:\n")
	print(x$values)
	invisible(x)
}
