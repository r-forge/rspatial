# npts(): return number points -> dim(x)[1]
# rbind.sdf
# is.na.sp.coords -> NA's not allowed in coordinates
# summary()
# delpoints,newpoints,selpoints,

#require(methods)

setClass("SpatialData", 
	representation(bbox = "matrix",
		proj4string = "CRS"),
	prototype = list(bbox = matrix(rep(NA, 6), 3, 2),
		proj4string = CRS(as.character(NA))),
	validity = function(object) {
		# print("called valid.SpatialData")
		n = spatial.dimension(object)
		if (n > 3 || n < 2)
			return("spatial.dimension should be either 2 or 3")
		if (!is.matrix(object@bbox))
			return("bbox should be a matrix")
		if (any(object@bbox[1:n, "max"] < object@bbox[1:n, "min"]))
			return("bbox is invalid: max < min")
		if (any(is.na(object@bbox)))
			return("bbox x and y values should never be NA")
		if (!is(object@proj4string, "CRS"))
			return("proj4string should be CRS")
		# validate proj4string here
		return(TRUE)
	}
)

setClass("SpatialDataFrame", 
	representation("SpatialData", 
		data = "data.frame", 
		coord.names = "character",
  		coord.columns = "integer"),
	prototype = list(new("SpatialData"), data = data.frame(), 
		coord.names = as.character(NA), coord.columns = integer(0)),
	validity = function(object) {
		# print("called valid.SpatialDataFrame")
		if (nrow(object@data) < 1)
			stop("no valid data present: too few rows")
		if (ncol(object@data) < 2)
			stop("no coordinates present: too few columns")
		return(TRUE)
	}
)

setClass("SpatialDataFrameGrid", 
	representation("SpatialDataFrame", 
		cellcentre.offset = "numeric",
		cellsize = "numeric",
		cells.dim = "integer"),
	prototype = list(new("SpatialDataFrame"), cellcentre.offset = numeric(0),
		cellsize = numeric(0), cells.dim = integer(0)),
	validity = function(object) {
		n = spatial.dimension(object)
		if (length(na.omit(object@cellcentre.offset)) > n)
			return("cellcentre.offset has incorrect dimension")
		if (length(na.omit(object@cellsize)) > n)
			return("cellsize has incorrect dimension")
		if (sum(object@cells.dim > 1) > n)
			return("cells.dim has incorrect dimension")
		return(TRUE)
	}
)

setClass("Polygon4",
	representation("SpatialData",
		coords = "matrix",
		nVerts = "integer",
		nParts = "integer",
		pStart.from = "integer",
		pStart.to = "integer",
		RingDir = "integer",
		ringDir = "integer",
		region.id = "character"),
	validity = function(object) {
			if (ncol(object@coords) !=2) {
				print("polygon should have 2 columns")
				return(FALSE)
			}
			return(TRUE)
		}
)

setClass("Polylist4",
	representation("SpatialData",
		polygons = "list",
		region.id = "character",
		within = "integer"),
	validity = function(object) {
		if (length(object@polygons) != length(object@region.id)) {
			print("length mismatch")
			return(FALSE)
		}
		if (any(unlist(lapply(object@polygons, function(x) 
			!is(x, "Polygon4"))))) {
			print("polygons not Polygon4 objects")
			return(FALSE)
		}
		return(TRUE)
	}
)



setClass("SpatialDataPolygons",
	representation("SpatialData",
		data = "data.frame",
		polygons = "Polylist4",
		has.holes = "logical"),
#	prototype = list(data = data.frame(),
#		polygons = as.list(NULL), has.holes = FALSE),
	validity = function(object) {
		if (nrow(object@data) != length(object@polygons@polygons))
			return("number of rows in data should equal number of polygons")
		valid = as.logical(sapply(object@polygons@polygons, verifyPolygon))
		if (any(!valid))
			return(paste("invalid polygon(s):", paste(which(!valid), 
				collapse = " ")))
		# perform more checks here?
		# check for holes, islands or all kinds of trouble?
		return(TRUE)
	}
)

SpatialDataFrame = function(data, coord.names, coord.columns, 
	proj4string = CRS(as.character(NA))) {
	if (missing(coord.names) && missing(coord.columns)) {
		if (dim(data)[2] > 2)
			stop("at least coordinate names or columns should be supplied")
		if (dim(data)[2] < 2)
			stop("data should have at least 2 columns (x- and y-coordinate)")
		warning("assuming columns 1 and 2 refer to x and y coordinate")
		coord.columns = 1:2
	} else if (missing(coord.names))
		coord.names = names(data)[coord.columns]
	else if (missing(coord.columns))
		coord.columns = match(coord.names, names(data))
	else if (any(match(coord.names, names(data)) != coord.columns))
		stop("SpatialDataFrame(): coord.names and coord.columns do not match")
	coordinates(data) = coord.names # this promotes data to SpatiatDataFrame
	proj4string(data) = proj4string
	data
}

## show & print:
## print.Sp... uses S3 method dispatch, but can pass the ... arguments
print.SpatialDataFrame = function(x, ...) { 
  cc = substring(paste(as.data.frame(t(signif(coordinates(x))))),2,999)
  # could be done in S-Plus by unpaste(x, "c")[[2]]
  coord.columns = match(x@coord.names, names(x@data))
  rhs = data.frame(x@data[,-coord.columns])
  names(rhs) = names(x@data)[-coord.columns]
  ndf = data.frame("coordinates" = cc, rhs)
  print(ndf, ...)
}

# setMethod("print", "SpatialDataFrame", PrintSpatialDataFrame)
ShowSpatialDataFrame = function(object) print.SpatialDataFrame(object)
setMethod("show", "SpatialDataFrame", ShowSpatialDataFrame)

bbox = function(sd) {
	if (!(is(sd, "SpatialData")))
		stop("function bbox only available for objects inheriting from SpatialData")
	sd@bbox
}

coordinates = function(sdf) { 
	if (!(is(sdf, "SpatialDataFrame")))
		stop("coordinates function only available for SpatialDataFrame objects")
	sdf@data[, sdf@coord.names] 
}

"coordinates<-" = function(obj, value) {
	if (is.null(obj)) {
		if (!(is.matrix(value) || is.data.frame(value)))
			stop("with no arguments, a data.frame or matrix should be supplied")
		p4args <- CRS(as.character(NA))
	} else {
		if (is(obj, "SpatialDataFrame")) {
			p4args <- obj@proj4string
			obj = obj@data
		} else {
			p4args <- CRS(as.character(NA))
		} # in which case we reset or change the spat. coords.
		if (!is.data.frame(obj))
			stop("obj is not a data.frame")
	}
	if (is.character(value)) {
		if (length(value) < 2 || length(value) > 3)
			stop("coordinate names should have length 2 or 3")
  		coord.columns = match(value, names(obj))
		if (any(is.na(coord.columns)))
			stop("coordinate names are not present in data.frame")
		cc = obj[, coord.columns]
	} else if (inherits(value, "formula")) {
		terms.l = terms(value)
		attr(terms.l, "intercept") = 0
		mf.locs = model.frame(terms.l, obj, na.action = na.pass) 
			# will check for missing values later
		cc = model.matrix(terms.l, mf.locs)
		value = colnames(cc)
		if (length(value) > 3 || length(value) < 2)
			stop("coordinates should have 2 or 3 columns")
  		coord.columns = match(value, names(obj))
		if (any(is.na(coord.columns)))
			stop("names in formula do not match columns in data.frame")
	} else if (is.matrix(value) || is.data.frame(value)) {
		cc = data.frame(value)
		if (NCOL(cc) > 3 || NCOL(cc) < 2)
			stop("coordinates should have 2 or 3 columns")
		value = colnames(value)
		if (is.null(value)) { # set up default names
			if (dim(cc)[2] == 2)
				value = c("x.coordinate", "y.coordinate")
			else
				value = c("x.coordinate", "y.coordinate", "z.coordinate")
			names(cc) = value
		}
		if (any(is.na(cc)))
			stop("missing values in coordinates not allowed")
		if (is.null(obj))  # e.g., unmarked point process
			obj = cc
		else {
		  if (any(!is.na(match(value, names(obj)))))
			stop("the default coordinate names are already present in object")
		  if (NROW(cc) != NROW(obj))
			stop("number of rows in coordinates and data.frame do not match")
		  obj = data.frame(cbind(cc, obj))
		}
		coord.columns = as.integer(1:NCOL(cc))
	} else
		stop("coordinates should be character, formula, matrix or data.frame")
	if (any(is.na(cc))) 
		stop("missing values in coordinates are not allowed")
	bbox = t(apply(cc, 2, range))
	dimnames(bbox) = list(value, c("min", "max"))
	new("SpatialDataFrame", 
		bbox = bbox,
		proj4string = p4args, 
		data = obj,
		coord.names = value,
		coord.columns = coord.columns)
}

setAs("SpatialDataFrame", "data.frame", function(from) { from@data })

as.data.frame.SpatialDataFrame = function(x, row.names, optional) 
	as(x, "data.frame")

# data.frame.SpatialDataFrame = function(x) as(x, "data.frame")

# try to get "[.data.frame" behaviour, but _always_ preserve columns,
# if needed add them
setMethod("[", "SpatialDataFrame", function(x, i, j, ..., drop = FALSE) {
		missing.i = missing(i)
		missing.j = missing(j)
		if (drop == TRUE)
			stop("coerce to data.frame first for drop = TRUE")
		nargs = nargs() # e.g., a[3,] gives 2 for nargs, a[3] gives 1.
		if (missing.i && missing.j) {
			i = TRUE
			j = TRUE
		} else if (missing.j && !missing.i) { 
			if (nargs == 2) {
				j = i
				i = TRUE
			} else {
				j = TRUE
			}
		} else if (missing.i && !missing.j)
			i = TRUE
		if (is.matrix(i))
			stop("matrix argument not supported in SpatialDataFrame selection")

		# from here on, i referes to rows and j to columns
		if (!(is.logical(j) && j == TRUE)) { # i.e., column selection
			if (is.character(j)) 
				j = match(j, names(x@data))
			if (!is.numeric(j))
				stop("column should be numeric now")
			cpos = match(x@coord.columns, j)
			if (any(!is.na(cpos))) { # coordinates are present: remove
				cpos = cpos[!is.na(cpos)]
				j = j[-cpos]
			}
			# add coordinates:
			j = c(x@coord.columns, j)
		}
		SpatialDataFrame(x@data[i, j, drop = FALSE], coord.names = x@coord.names, 
			proj4string = x@proj4string)
	}
)

setMethod("[", "SpatialDataFrameGrid",
	function(x, i, j, ..., drop = FALSE) {
		n.args = nargs()
		if (!missing(drop))
			stop("don't supply drop: it needs to be FALSE anyway")
		if (missing(i) && missing(j))
			return(x)
		if (missing(j)) {
			if (n.args == 3) # with a , : x[i,]
				res = as(x, "SpatialDataFrame")[i = i, TRUE, ...]
			else # withouth a , : x[i]
				res = as(x, "SpatialDataFrame")[TRUE, j = i, ...]
		} else if (missing(i))
			res = as(x, "SpatialDataFrame")[TRUE, j = j, ...]
		else
			res = as(x, "SpatialDataFrame")[i = i, j = j, ...]
		gridded(res) = TRUE
		res
	}
)

proj4string = function(sd) { 
	if (!extends(class(sd), "SpatialData"))
		stop("proj4string only works for classes inheriting from SpatialData")
	sd@proj4string@projargs
}

"proj4string<-" = function(sd, value) { 
	if (!extends(class(sd), "SpatialData"))
		stop("proj4string only works for classes inheriting from SpatialData")
	if (!is(value, "CRS"))
		stop("assigned value must be CRS object")
	sd@proj4string = value; 
	sd
}

is.projected = function(sd) {
	if (!is(sd, "SpatialData"))
		stop("is.projected only works for classes inheriting from SpatialData")
	p4str <- proj4string(sd)
	if (is.na(p4str)) 
		return(as.logical(NA))
	else {
		res <- grep("latlong", p4str, fixed=TRUE)
		if (length(res) == 0)
			return(TRUE)
		else 
			return(FALSE)
	}
}

summary.SpatialData = function(object, ...) {
	obj = list()
	obj[["bbox"]] = object@bbox
	obj[["is.projected"]] = is.projected(object)
	obj[["proj4string"]] = object@proj4string@projargs
	if (is(object, "SpatialDataFrame") && 
			(length(object@coord.columns) < NCOL(object@data)))
		obj[["data"]] = summary(object@data[-object@coord.columns])
	if (is(object, "SpatialDataFrameGrid"))
		obj[["grid"]] = gridparameters(object)
	if (is(object, "SpatialDataPolygons")) {
		obj[["n.polygons"]] = length(object@polygons@polygons)
		obj[["data"]] = summary(object@data)
	}
	class(obj) = "summary.SpatialData"
	obj
}

summary.SpatialDataFrame = summary.SpatialData
summary.SpatialDataFrameGrid = summary.SpatialData
summary.SpatialDataPolygons = summary.SpatialData

# setMethod("summary", "SpatialDataFrame", summary.SpatialData)

print.summary.SpatialData = function(x, ...) {
	cat("Coordinates:\n")
	print(x[["bbox"]])
	cat(paste("Is projected:", x[["is.projected"]], "\n"))
	cat(paste("proj4string : [", x[["proj4string"]], "]\n", sep=""))
	if (!is.null(x$n.polygons))
		print(paste("Number of polygons:", x$n.polygons))
	if (!is.null(x$grid)) {
		cat("Grid attributes:\n")
		print(x$grid)
	}
	if (!is.null(x$data)) {
		cat("Data attributes:\n")
		print(x$data)
	}
	invisible(x)
}

plot.SpatialDataFrame = function(x, xlab = x@coord.names[1], 
		ylab = x@coord.names[2], asp = 1, ...) {
	df = x@data
	col = x@coord.columns
	plot(df[, col[1]], df[, col[2]], asp = asp, xlab = xlab, ylab = ylab, ...)
}

plot.SpatialDataFrameGrid = function(x, xlab = x@coord.names[1], 
		ylab = x@coord.names[2], asp = 1, ...) {
	plot.SpatialDataFrame(as(x, "SpatialDataFrame"), xlab = xlab, 
		ylab = ylab, asp = asp, ...)
}

formula.SpatialDataFrame = function(x, ...) {
	nam = x@coord.names
	if (length(nam) == 2)
		rhs = paste(nam[1], nam[2], sep = "+")
	if (length(nam) == 3)
		rhs = paste(nam[1], nam[2], nam[3], sep = "+")
	as.formula(paste("~", rhs))
}

formula.SpatialDataFrameGrid = function(x, ...) {
	formula(as(x, "SpatialDataFrame"))
}

spatial.dimension = function(sd) {
	if (!is(sd, "SpatialData"))
		stop("spatial.dimension only for objects extending SpatialData")
	NROW(sd@bbox)
}

####### SpatialDataFrameGrid class
"gridded<-" = function(obj, value) {
	if (!is(obj, "SpatialDataFrame"))
		stop("object should be of or extend class SpatialDataFrame")
	if (is.logical(value)) {
		if (value == TRUE) {
			if (!is(obj, "SpatialDataFrameGrid"))
				obj = as.SDFgrid(obj)
		} else {
			if (is(obj, "SpatialDataFrameGrid"))
				obj = as.SDF(obj)
		}
		return(obj)
	}
	# further deal with more complex forms of value
	stop("more complex forms of value not yet implemented")
}

gridded = function(obj) { return(is(obj, "SpatialDataFrameGrid")) }

gridparameters = function(obj) { 
	if (inherits(obj, "SpatialDataFrameGrid"))
		return(data.frame( 
			cellcentre.offset= obj@cellcentre.offset,
			cellsize = obj@cellsize,
			cells.dim = obj@cells.dim, 
			row.names = obj@coord.names))
	else 
		return(numeric(0))
}

as.SDFgrid = function(from) {
	n = spatial.dimension(from)
	ret = new("SpatialDataFrameGrid", 
		bbox = from@bbox,
		proj4string = from@proj4string, 
		data = from@data,
		coord.names = from@coord.names,
		coord.columns = from@coord.columns,
		cellcentre.offset = as.numeric(rep(NA, n)),
		cellsize = as.numeric(rep(NA, n)),
		cells.dim = as.integer(rep(0, n)))

	cc = coordinates(from)
	for (i in 1:n) { # loop over x, y, and possibly z
		x = cc[, i]
    	xx = sort(unique(x))
    	difx = diff(xx)
    	if (diff(range(unique(difx))) > 1e-15) 
       		stop(paste(from@coord.names[i], "intervals are not constant"))
		ret@cellsize[i] = mean(difx)
		ret@cellcentre.offset[i] = min(xx)
    	ret@cells.dim[i] = length(xx)
	}
	ret
}

#setAs("SpatialDataFrame", "SpatialDataFrameGrid", as.SDFgrid)

as.SDF = function(from) { # strip all grid attributes
	new("SpatialDataFrame", 
		bbox = from@bbox,
		proj4string = from@proj4string, 
		data = from@data,
		coord.names = from@coord.names,
		coord.columns = from@coord.columns)
}

#setAs("SpatialDataFrameGrid", "SpatialDataFrame", as.SDF)

as.SD = function(from) { # strip all grid & data.frame attributes
	new("SpatialData", 
		bbox = from@bbox,
		proj4string = from@proj4string)
}
#setAs("SpatialDataFrame", "SpatialData", as.SD)

# as(x, "data.frame"):
setAs("SpatialDataFrameGrid", "data.frame", function(from) { from@data })

# as.data.frame(x); 

as.data.frame.SpatialDataFrameGrid = function(x, row.names, optional) 
	as(x, "data.frame")

row.names.SpatialDataFrame = function(x) row.names(x@data)
row.names.SpatialDataFrameGrid = function(x) row.names(x@data)

# polygon stuff:
verifyPolygon = function(x) {
	if (nrow(x@coords) < 4) {
		print("polygon should have at least 4 points")
		return(FALSE)
	}
	if (ncol(x@coords) != 2) {
		print("polygon should have 2 columns")
		return(FALSE)
	}
#	if (any(is.na(x@coords))) {
#		print("polygon should not contain missing values") 
#		return(FALSE)
#	}
# NAs permitted for multiple polygons
# closure should be for multiple parts
#	if (!all(x@coords[1,] == x@coords[nrow(x@coords),])) {
#		print("polygon should be closed (first point == last point)")
#		return(FALSE)
#	}
	return(TRUE)
}

SpatialDataPolygons = function(data, polygons) {
#	if (missing(data))
#		data = getMeanDF(polygons@polygons)
	polygons(data) = polygons # promotes data frame to SpatialDataPolygons
	data
}

#getMeanDF = function(polygons) {
#	mean.x = function(x) mean(x[-1,1])
#	mean.y = function(x) mean(x[-1,2])
#	data.frame(x.mean = sapply(polygons, mean.x),
#			y.mean = sapply(polygons, mean.y))
#}

"polygons<-" = function(obj, value) {
#	if (!is.null(obj) && !is.data.frame(obj))
	if (!is.data.frame(obj))
		stop("obj is not a data.frame")
	if (any(x <- !as.logical(sapply(value@polygons, verifyPolygon))))
		stop(paste("polygon(s)", paste(which(x), collapse = " "), "not valid"))
	rangePolygons = function(x) as.vector(apply(x@coords, 2, range))
	r = t(sapply(value@polygons, rangePolygons))
	bbox = matrix(NA, 2, 2)
	bbox[1,1] = min(r[,1], na.rm=TRUE)
	bbox[1,2] = max(r[,2], na.rm=TRUE)
	bbox[2,1] = min(r[,3], na.rm=TRUE)
	bbox[2,2] = max(r[,4], na.rm=TRUE)
	colnames(bbox) = c("min", "max")
#	if (is.null(obj))
#		obj = getMeanDF(value@polygons)
	# verify has.holes thing, how do we provide this?
	new("SpatialDataPolygons", 
		bbox = bbox,
		proj4string = CRS(as.character(NA)), 
		data = obj,
		polygons = value,
		has.holes = FALSE)
}

polygons = function(obj) { 
	if (!(is(obj, "SpatialDataPolygons")))
		stop("polygons function only available for SpatialDataPolygons objects")
	obj@polygons
}

setAs("SpatialDataPolygons", "data.frame", function(from) { from@data })

as.data.frame.SpatialDataPolygons = function(x, row.names, optional)
	as(x, "data.frame")

#if (require("maps")) { # should test this require() thing further ...
#	setClass("map") # dummy -- "map" is an S3 class of library(maps)
#	setAs("map", "SpatialDataPolygons", function(from) { 
#			SpatialDataPolygons(polygons = map2polys(from))
#		}
#	)
#}

#if (require("pixmap")) {
# ... # set up conversion from/to pixmap <<-->> SpatialDataFrameGrid
#}

#map2polys = function(map) {
#	get.poly = function(x, map) {
#		r = x[1]:x[2]
#		c(map$x[r], map$y[r])
#	}
#	fold.poly = function(x) {
#		n = length(x)
#		half = n/2
#		cbind(xcoord = x[1:half], ycoord = x[(half+1):n])
#	}
#	if (!inherits(map, "map"))
#		stop("argument map should be of class map")
#	xc = map$x
#	n = length(xc)
#	breaks = which(is.na(xc))
#	range.limits = cbind(start = c(1, breaks + 1), end = c(breaks - 1, n))
#	lst = apply(range.limits, 1, get.poly, map = map)
#	names(lst) = map$names
#	lapply(lst, fold.poly)
#}

