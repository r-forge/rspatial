setClass("SpatialCell", 
	representation("SpatialPoints", grid = "SpatialGridded",
		grid.index = "integer"),
	validity = function(object) {
		# check that dimensions, proj4string and bbox do not conflict
		return(TRUE)
	}
)

SpatialCell = function(points, tolerance = 10 * .Machine$double.eps) {
	if (!inherits(points, "SpatialPoints"))
		stop("points should be or extend SpatialPoints")
	else
		points = as(points, "SpatialPoints")
	grid = points2grid(points, tolerance)
	new("SpatialCell", points, grid = grid, 
		grid.index = GetGridIndex(coordinates(points), grid))
}

setMethod("coordinates", "SpatialCell", function(obj) obj@coords)

GetGridIndex = function(points, grid) {
	n = ncol(points)
	idx = numeric(nrow(points))
	idx = round((points[,1] - grid@cellcentre.offset[1])/grid@cellsize[1]) + 1
	yi = grid@cells.dim[2] - 
		(round((points[,2] - grid@cellcentre.offset[2])/grid@cellsize[2]) + 1)
	idx = idx + grid@cells.dim[1] * yi
	if (n > 2) {
		zi = round((points[,3] - grid@cellcentre.offset[3])/grid@cellsize[3])
		idx = idx + (grid@cells.dim[1] * grid@cells.dim[2]) * zi
	}
	if (min(idx) < 1 || max(idx) > .NumberOfCells(grid))
		stop("index outside boundaries")
	as.integer(round(idx))
}

plot.SpatialCell = function(x, ...) {
	plot(as(x, "SpatialPoints"), ...)
}

subset.SpatialCell <- function(x, subset, select, drop = FALSE, ...) {
	xSP <- as(x, "SpatialPoints")
	if (missing(select)) select <- colnames(coordinates(xSP))
	res <- subset(xSP, subset=subset, select=select, drop = drop, ...)
	gridded(res) = TRUE
	res
}

setMethod("[", "SpatialCell",
#ifdef R
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

summary.SpatialCell = summary.Spatial

print.summary.SpatialCell = print.summary.Spatial

setIs("SpatialCell", "SpatialGridded", coerce = function(from) from@grid)
