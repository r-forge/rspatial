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

setClass("SpatialCell", 
	representation("SpatialPoints", grid = "SpatialGridded",
		grid.index = "integer"),
	validity = function(object) {
		# check that dimensions, proj4string and bbox do not conflict
		return(TRUE)
	}
)

SpatialCell = function(points) {
	if (!extends(class(points), "SpatialPoints"))
		stop("points should be or extend SpatialPoints")
	else
		points = as(points, "SpatialPoints")
	grid = points2grid(points)
	new("SpatialCell", points, grid = grid, grid.index = getgridindex(points, grid))
}

points2grid = function(points) {
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
    	if (diff(range(unique(difx))) > 1e-15) 
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

getgridindex = function(points, grid) {
	integer(0)
}

setClass("SpatialCellDataFrame",
	representation("SpatialCell", data = "data.frame"),
	validity = function(object) {
		# check nrows in data.frame equal n points
		if (nrow(object@coords) != nrow(object@data))
			stop("unequal number of objects in points and data.frame")
		return(TRUE)
	}
)

SpatialCellDataFrame = function(points, data) {
	new("SpatialCellDataFrame", SpatialCell(SpatialPoints(points)), data = data)
}

"gridded<-" = function(obj, value) {
	if (!extends(class(obj), "Spatial"))
		stop("object should be of or extend class Spatial")
	if (is(obj, "SpatialCellDataFrame")) {
		if (value == FALSE)
			return(SpatialPointsDataFrame(obj@coords, obj@data))
	} else if (is(obj, "SpatialCell")) {
		if (value == FALSE)
			return(as(obj, "SpatialPoints"))
	} else if (is(obj, "SpatialPointsDataFrame")) {
		if (value == TRUE)
			return(SpatialCellDataFrame(obj@coords, obj@data))
	} else if (is(obj, "SpatialPoints")) {
		if (value == TRUE)
			return(SpatialCell(obj))
	}
	# further deal with more complex forms of value
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
	cat("Grid parameters\n")
	print(x$values)
	invisible(x)
}
setMethod("show", "SpatialGridded", function(object) summary(obj))
summary.SpatialCell = function(object, ...) {
	ret = list()
	# ret[["points"]] = summary(object@coords)
	ret[["grid"]] = summary(object@grid)
	class(ret) = "summary.SpatialCell"
	ret
}
print.summary.SpatialCell = function(x, ...) {
	# print(x$points)
	print(x$grid)
	invisible(x)
}
summary.SpatialCellDataFrame = function(object, ...) {
	ret = list()
	ret[["data"]] = summary(object@data)
	ret[["cell"]] = summary(as(object, "SpatialCell"))
	class(ret) = "summary.SpatialCellDataFrame"
	ret
}
print.summary.SpatialCellDataFrame = function(x, ...) {
	print(x$data)
	print(x$cell)
	invisible(x)
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

setMethod("[", "SpatialCellDataFrame",
#ifdef R
	function(x, i, j, ..., drop = FALSE) {
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
)

gridparameters = function(obj) { 
	if (inherits(obj, "SpatialGridded"))
		return(data.frame( 
			cellcentre.offset= obj@cellcentre.offset,
			cellsize = obj@cellsize,
			cells.dim = obj@cells.dim))
	else 
		return(numeric(0))
}
