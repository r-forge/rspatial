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
		if (i == 2) # y-axis is the exception--index  starting at top of map, and decreasing:
			args[[i]] = obj@cellcentre.offset[i] + obj@cellsize[i] * ((obj@cells.dim[i] - 1):0)
		else
			args[[i]] = obj@cellcentre.offset[i] + obj@cellsize[i] * (0:(obj@cells.dim[i] - 1))
	}
	names(args) = dimnames(obj@bbox)[[1]]
	args
}

setMethod("coordinates", "SpatialGridded", function(obj) {
	cc = do.call("expand.grid", coordinatevalues(obj))
	as.matrix(sapply(cc, as.numeric))
})

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

setClass("SpatialCellDataFrame",
	representation("SpatialCell", data = "data.frame", coords.nrs = "numeric"),
	validity = function(object) {
		# check nrows in data.frame equal n points
		if (nrow(object@coords) != nrow(object@data))
			stop("unequal number of objects in points and data.frame")
		return(TRUE)
	}
)

SpatialCellDataFrame = function(points, data, coords.nrs = numeric(0)) {
	new("SpatialCellDataFrame", SpatialCell(SpatialPoints(points)), 
		data = data, coords.nrs = coords.nrs)
}

setMethod("coordinates", "SpatialCellDataFrame", 
	function(obj) coordinates(as(obj, "SpatialCell")))

.NumberOfCells = function(x) {
	if (!is(x, "SpatialGridded"))
		stop(".NumberOfCells only works on objects of class SpatialGridded")
	cd = x@cells.dim
	n = cd[1]
	for (i in 2:length(cd))
		n = n * cd[i]
	n
}

setClass("SpatialGriddedDataFrame", 
	representation("SpatialGridded", data = "data.frame"),
	validity = function(object) {
		if (.NumberOfCells(object) != nrow(object@data))
			stop("nr of cells in grid does not equal nr of rows in data")
		return(TRUE)
	}
)

SpatialGriddedDataFrame = function(grid, data) {
	new("SpatialGriddedDataFrame", grid, data = data)
}

setMethod("coordinates", "SpatialGriddedDataFrame", 
	function(obj) coordinates(as(obj, "SpatialGridded")))

as.SpatialGriddedDataFrame.SpatialCellDataFrame = function(from)  {
	fd = from@data
	data = list()
	n = .NumberOfCells(from@grid)
	for (i in seq(along=fd)) {
		if (is.factor(fd[[i]]))
			stop("cannot (yet) coerce factor variables")
		else if (is.integer(fd[[i]]))
			data[[i]] = rep(as.integer(NA), n)
		else if (is.numeric(fd[[i]]))
			data[[i]] = rep(as.numeric(NA), n)
	}
	data = data.frame(data)
	names(data) = names(fd)
	for (i in seq(along=fd))
		data[from@grid.index, i] = fd[[i]]
	#print(n)
	#print(dim(data))
	#print(from@grid)
	#print(data)
	SpatialGriddedDataFrame(from@grid, data)
}

setIs("SpatialCellDataFrame", "SpatialGriddedDataFrame", 
	coerce = as.SpatialGriddedDataFrame.SpatialCellDataFrame)

as.matrix.SpatialCellDataFrame = function(x) {
	as.matrix(as(x, "SpatialGriddedDataFrame"))
}

as.matrix.SpatialGriddedDataFrame = function(x) {
	if (ncol(x@data) > 1)
		warning("as.matrix.SpatialCellDataFrame uses first column;\n pass subset or [] for other columns")
	matrix(x@data[[1]], x@cells.dim[1], x@cells.dim[2], byrow=FALSE)
}


as.data.frame.SpatialCellDataFrame <- function(x, row.names = NULL, 
	optional = FALSE)
	as.data.frame(as(x, "SpatialPointsDataFrame"), row.names = row.names, optional = optional)

as.data.frame.SpatialGriddedDataFrame <- function(x, row.names = NULL, 
	optional = FALSE) {
	as.data.frame(as(x, "SpatialCellDataFrame"), row.names = row.names, optional = optional)
	#crds <- coordinates(x)
	#df <- data.frame(x@data, as.data.frame(crds))
	#df
}

names.SpatialCellDataFrame <- function(x) {
	names(as.data.frame(x))
}

as.data.frame.SpatialCellDataFrame = function(x, row.names, optional) {
	as(x, "data.frame")
}

setAs("SpatialCellDataFrame", "data.frame", 
	function(from) as(as(from, "SpatialPointsDataFrame"), "data.frame")
)

setIs("SpatialCellDataFrame", "SpatialPointsDataFrame", 
	coerce = function(from) SpatialPointsDataFrame(from@coords, from@data, from@coords.nrs)
)

setIs("SpatialCellDataFrame", "SpatialGridded", coerce = function(from) from@grid)

setIs("SpatialCell", "SpatialGridded", coerce = function(from) from@grid)

as.SpatialCellDataFrame.SpatialGriddedDataFrame = function(from) {
	new("SpatialCellDataFrame", 
		new("SpatialCell", SpatialPoints(coordinates(from)),
			grid = as(from, "SpatialGridded"), 
			grid.index = 1:.NumberOfCells(from)),
		data = from@data, coords.nrs = numeric(0)
	)
}

setAs("SpatialGriddedDataFrame", "SpatialCellDataFrame", 
	as.SpatialCellDataFrame.SpatialGriddedDataFrame)

print.SpatialCell = function(x, ...) {
	cat("Object of class SpatialCell\n")
	print(as(x, "SpatialGridded"))
	print(as(x, "SpatialPoints"))
	invisible(x)
}

print.SpatialCellDataFrame = function(x, ...) {
	cat("Object of class SpatialCellDataFrame\n")
	print(as(x, "SpatialGridded"))
	print(as(x, "SpatialPointsDataFrame"))
	invisible(x)
}
names.SpatialCellDataFrame = function(x) names(as(x, "SpatialPointsDataFrame"))

print.SpatialGriddedDataFrame = function(x, ...) {
	cat("Object of class SpatialGriddedDataFrame\n")
	print(as(x, "SpatialGridded"))
	# print(as(as(x, "SpatialCellDataFrame"), "SpatialPointsDataFrame"))
	cat("Data:\n")
	print(summary(x@data))
	invisible(x)
}

print.SpatialGridded = function(x, ...) {
	res = data.frame(rbind(x@cellcentre.offset, x@cellsize, as.numeric(x@cells.dim)))
	rownames(res) = c("cellcentre.offset", "cellsize", "cells.dim")
	print(res)
	invisible(res)
}

"gridded<-" = function(obj, value) {
#	if (!extends(class(obj), "Spatial"))
#		stop("object should be of or extend class Spatial")
	if (is.logical(value)) {
		if (is(obj, "SpatialCellDataFrame")) {
			if (value == FALSE)
				return(SpatialPointsDataFrame(obj@coords, obj@data))
		} else if (is(obj, "SpatialCell")) {
			if (value == FALSE)
				return(as(obj, "SpatialPoints"))
		} else if (is(obj, "SpatialPointsDataFrame")) {
			if (value == TRUE)
				return(SpatialCellDataFrame(obj@coords, obj@data, obj@coords.nrs))
		} else if (is(obj, "SpatialPoints")) {
			if (value == TRUE)
				return(SpatialCell(obj))
		} else if (is(obj, "data.frame") && 
				(is(value, "formula") || is(value, "character"))) {
			coordinates(obj) = value
			gridded(obj) = TRUE
		}
	} else {
		if (is(value, "SpatialGridded"))
			return(SpatialGriddedDataFrame(value, data.frame(obj)))
		else
			stop(paste("cannot deal with value of class"), class(value))
		# further deal with more complex forms of value
	}
	obj
}

griddedfn = function(obj) { 
	return (extends(class(obj), "SpatialGridded") ||
		extends(class(obj), "SpatialCell")) 
}

setMethod("gridded", "Spatial", function(obj) griddedfn(obj))

plot.SpatialCell = function(x, ...) {
	plot(as(x, "SpatialPoints"), ...)
}

plot.SpatialCellDataFrame = function(x, ...) {
	plot(as(x, "SpatialPoints"), ...)
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

#summary.SpatialCell = function(object, ...) {
#	ret = summary(as(object, "Spatial"))
#	# ret[["points"]] = summary(object@coords)
#	ret[["grid"]] = summary(object@grid)
#	class(ret) = "summary.SpatialCell"
#	ret
#}

#print.summary.SpatialCell = function(x, ...) {
#	# print(x$points)
#	print(x$grid)
#	invisible(x)
#}

#summary.SpatialCellDataFrame = function(object, ...) {
#	ret = list()
#	ret[["data"]] = summary(object@data)
#	ret[["cell"]] = summary(as(object, "SpatialCell"))
#	class(ret) = "summary.SpatialCellDataFrame"
#	ret
#}
#print.summary.SpatialCellDataFrame = function(x, ...) {
#	print(x$data)
#	print(x$cell)
#	invisible(x)
#}

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
#else
#%	function(x, ..., drop = TRUE) {
#%		res = as(x, "SpatialPoints")
#%		if (missing(drop))
#%			res = "["(res, ...)
#%		else
#%			res = "["(res, ..., drop = drop)
#%		gridded(res) = TRUE
#%		res
#%	}
#endif
)

subset.SpatialCellDataFrame <- function(x, subset, select, drop = FALSE, ...) {
    if (version$major == 2 & version$minor < 1 ) {
	subset.matrix <- function (x, subset, select, drop = FALSE, ...) {
    		if (missing(select)) 
        		vars <- TRUE
    		else {
        		nl <- as.list(1:ncol(x))
        		names(nl) <- colnames(x)
        		vars <- eval(substitute(select), nl, parent.frame())
    		}
    		if (!is.logical(subset)) 
        		stop("'subset' must be logical")
    		x[subset & !is.na(subset), vars, drop = drop]
	}
    }
	xSP <- coordinates(x)
	dfSP <- as.data.frame(x)
	cselect <- colnames(xSP)
	points <- subset(xSP, subset=subset, select=cselect, drop = drop, ...)
	if (missing(select)) select <- names(dfSP)
	data <- subset(dfSP, subset=subset, select=select, drop = drop, ...)
	SCDF <- SpatialCellDataFrame(points, data)
	SCDF
}

"[.SpatialCellDataFrame" <- function(x, i, j, ... , drop = FALSE) {
#	missing.i <-  missing(i)
#	missing.j <- missing(j)
#	if (missing.i & missing.j) return(x)
#	if (drop)
#		stop("coerce to data.frame first for drop = TRUE")
#	if (missing.i) {
#		cres <- coordinates(x)
#		data <- as.data.frame(x)[, j, drop = FALSE]
#	} else {
#		if (missing.j) {
#			if (nargs == 2) {
#				j <- i
#				i <- TRUE
#			} else j <- TRUE
#		}
#		cres <- coordinates(x)[i, , drop=FALSE]
#		data <- as.data.frame(x)[i, j, drop = FALSE]
#	}
#	res <- SpatialCellDataFrame(cres, data)
#	res
	n.args = nargs()
	if (!missing(drop))
		stop("don't supply drop: it needs to be FALSE anyway")
	if (missing(i) && missing(j))
		return(x)
	if (missing(j)) {
		if (n.args == 3) # with a , : x[i,]
			res = as(x, "SpatialPointsDataFrame")[i = i, TRUE, ...]
		else # withouth a , : x[i]
			res = as(x, "SpatialPointsDataFrame")[TRUE, j = i, ...]
	} else if (missing(i))
		res = as(x, "SpatialPointsDataFrame")[TRUE, j = j, ...]
	else
		res = as(x, "SpatialPointsDataFrame")[i = i, j = j, ...]
	gridded(res) = TRUE
	res
}

"[[.SpatialCellDataFrame" =  function(x, ...) {
	x@data[[...]]
}

"[[<-.SpatialCellDataFrame" =  function(x, i, j, value) {
	if (!missing(j))
		stop("only valid calls are x[[i]] <- value")
	x@data[[i]] <- value
	x
}

"[.SpatialGriddedDataFrame" =  function(x, i, j, ..., drop = F) {
	if (!missing(drop))
		stop("don't supply drop: it needs to be FALSE anyway")
	n.args = nargs()
	if (missing(i) && missing(j))
		return(x)
	if (missing(j)) {
		if (n.args == 3) # with a , : x[i,]
			stop("row selection not implemented for this class")
		else # withouth a , : x[i]
			x@data = x@data[TRUE, j = i, ..., drop = FALSE]
	} else if (missing(i))
		x@data = x@data[TRUE, j = j, ...]
	else
		stop("row selection not implemented for this class")
	x
}

"[[.SpatialGriddedDataFrame" =  function(x, ...) {
	x@data[[...]]
}

"[[<-.SpatialGriddedDataFrame" =  function(x, i, j, value) {
	if (!missing(j))
		stop("only valid calls are x[[i]] <- value")
	x@data[[i]] <- value
	x
}

#setMethod("[", "SpatialCellDataFrame",
#ifdef R
#	function(x, i, j, ..., drop = FALSE) {
#		n.args = nargs()
#		if (!missing(drop))
#			stop("don't supply drop: it needs to be FALSE anyway")
#		if (missing(i) && missing(j))
#			return(x)
#		if (missing(j)) {
#			if (n.args == 3) # with a , : x[i,]
#				res = as(x, "SpatialPointsDataFrame")[i = i, TRUE, ...]
#			else # withouth a , : x[i]
#				res = as(x, "SpatialPointsDataFrame")[TRUE, j = i, ...]
#		} else if (missing(i))
#			res = as(x, "SpatialPointsDataFrame")[TRUE, j = j, ...]
#		else
#			res = as(x, "SpatialPointsDataFrame")[i = i, j = j, ...]
#		gridded(res) = TRUE
#		res
#	}
#else
#%	function(x, ..., drop = TRUE) {
#%		res = as(x, "SpatialPointsDataFrame")
#%		if (missing(drop))
#%			res = "["(res, ...)
#%		else
#%			res = "["(res, ..., drop = drop)
#%		gridded(res) = TRUE
#%		res
#%	}
#endif
#)

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

summary.SpatialCell = summary.Spatial
summary.SpatialCellDataFrame = summary.Spatial
summary.SpatialGriddedDataFrame = summary.Spatial

print.summary.SpatialCell = print.summary.Spatial
print.summary.SpatialCellDataFrame = print.summary.Spatial
print.summary.SpatialGriddedDataFrame = print.summary.Spatial
