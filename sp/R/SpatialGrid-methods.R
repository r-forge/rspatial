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

areaSpatialGrid = function(obj) {
	cellarea = prod(obj@grid@cellsize[1:2])
	if (is(obj, "SpatialGridDataFrame"))
		nrow(na.omit(obj@data)) * cellarea
	else if (fullgrid(obj))
		prod(obj@grid@cells.dim) * cellarea
	else
		length(obj@grid.index) * cellarea
}

gridparameters = function(obj) { 
	if (is(obj, "SpatialGrid"))
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
	x = rbind(grid@cellcentre.offset, 
			grid@cellcentre.offset + (grid@cells.dim - 1) * grid@cellsize)
	SpatialPoints(x)
}

getGridIndex = function(cc, grid, all.inside = TRUE) {
	n = ncol(cc)
	idx = rep(1, nrow(cc))
	cumprod = 1
	for (i in 1:n) {
		this.idx = round((cc[,i] - grid@cellcentre.offset[i])/grid@cellsize[i])
		if (i == 2)
			this.idx = grid@cells.dim[2] - (this.idx + 1)
		outside = this.idx >= grid@cells.dim[i] | this.idx < 0
		if (any(outside)) {
			if (all.inside) {
				print(summary(this.idx))
				stop("this.idx out of range")
			} else
				this.idx[outside] = NA
		}
		idx = idx + this.idx * cumprod
		cumprod = cumprod * grid@cells.dim[i]
	}
	outside = idx < 1 | idx > .NumberOfCells(grid)
	if (any(na.omit(outside))) {
		print(summary(idx))
		stop("index outside boundaries")
	}
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
