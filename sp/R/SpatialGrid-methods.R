SpatialGrid = function(points = NULL, grid = NULL, 
		tolerance = 10 * .Machine$double.eps, proj4string = CRS(as.character(NA))) {
	if (!is.null(points)) {
		if (!inherits(points, "SpatialPoints"))
			stop("points should be or extend SpatialPoints")
		else
			points = as(points, "SpatialPoints")
		grid = points2grid(points, tolerance)
		new("SpatialGrid", points, grid = grid, 
			grid.index = getGridIndex(coordinates(points), grid))
	} else {
		if (is.null(grid))
			stop("points and grid are both NULL")
		new("SpatialGrid", SpatialPoints(coordinates(boguspoints(grid))),
			grid = grid, grid.index = integer(0))
	}
}

setMethod("coordinates", "SpatialGrid", function(obj) { 
		if (length(obj@grid.index) > 0) # retrieve them:
			obj@coords
		else # compute them:
			coordinates(obj@grid)
	}
)

getGridTopology = function(obj) {
	if (!is(obj, "SpatialGrid"))
		stop("object is or does not extend class SpatialGrid")
	obj@grid
}

gridparameters = function(obj) { 
	if (is(obj, "SpatialGridded"))
		obj = obj@grid
	if (is(obj, "GridTopology"))
		return(data.frame(
			cellcentre.offset = obj@cellcentre.offset,
			cellsize = obj@cellsize,
			cells.dim = obj@cells.dim))
	if (is(obj, "SpatialGrid"))
		return(gridparameters(obj@grid))
	return(numeric(0))
}

boguspoints = function(grid) {
	x = c(x = grid@cellcentre.offset, 
		y = grid@cellcentre.offset + (grid@cells.dim - 1) * grid@cellsize)
	SpatialPoints(matrix(x, 2, length(grid@cellcentre.offset), byrow = TRUE))
}

getGridIndex = function(cc, grid) {
	n = ncol(cc)
	idx = numeric(nrow(cc))
	idx = round((cc[,1] - grid@cellcentre.offset[1])/grid@cellsize[1]) + 1
	yi = grid@cells.dim[2] - 
		(round((cc[,2] - grid@cellcentre.offset[2])/grid@cellsize[2]) + 1)
	idx = idx + grid@cells.dim[1] * yi
	if (n > 2) {
		zi = round((cc[,3] - grid@cellcentre.offset[3])/grid@cellsize[3])
		idx = idx + (grid@cells.dim[1] * grid@cells.dim[2]) * zi
	}
	if (min(idx) < 1 || max(idx) > .NumberOfCells(grid))
		stop("index outside boundaries")
	as.integer(round(idx))
}

plot.SpatialGrid = function(x, ...) {
	plot(as(x, "SpatialPoints"), ...)
}

subset.SpatialGrid <- function(x, subset, select, drop = FALSE, ...) {
	xSP <- as(x, "SpatialPoints")
	if (missing(select)) select <- colnames(coordinates(xSP))
	res <- subset(xSP, subset=subset, select=select, drop = drop, ...)
	gridded(res) = TRUE
	res
}

setMethod("[", "SpatialGrid",
	function(x, i, j, ..., drop = FALSE) {
		n.args = nargs()
		if (!missing(drop))
			stop("don't supply drop: it needs to be FALSE anyway")
		if (missing(i) && missing(j))
			return(x)
		if (missing(j)) {
			if (n.args == 3) # with a , : x[i,]
				res = as(x, "SpatialPoints")[i = i, TRUE, ...]
			else # withouth a , : x[i]
				res = as(x, "SpatialPoints")[TRUE, j = i, ...]
		} else if (missing(i))
			res = as(x, "SpatialPoints")[TRUE, j = j, ...]
		else
			res = as(x, "SpatialPoints")[i = i, j = j, ...]
		gridded(res) = TRUE
		res
	}
)

summary.SpatialGrid = summary.Spatial

print.summary.SpatialGrid = print.summary.Spatial

print.SpatialGrid = function(x, ...) {
	cat("Object of class SpatialGrid\n")
	print(summary(x@grid))
	print(as(x, "SpatialPoints"))
	invisible(x)
}
