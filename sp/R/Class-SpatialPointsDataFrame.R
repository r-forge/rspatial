setClass("SpatialPointsDataFrame",
	representation("SpatialPoints", data = "data.frame"),
	prototype = list(new("SpatialPoints"), data = data.frame()),
	validity = function(object) {
		if (!inherits(object@data, "data.frame"))
			stop("data should be of class data.frame")
		if (nrow(object@coords) < 1)
			stop("no points set: too few rows")
		if (ncol(object@coords) <= 1)
			stop("no points set: too few columns")
		if (nrow(object@data) != nrow(object@coords))
		  stop("number of rows in data.frame and SpatialPoints don't match")
		return(TRUE)
	}
)

"SpatialPointsDataFrame" = function(coords, data) {
	new("SpatialPointsDataFrame", SpatialPoints(coords), data = data)
}

coordinates.SPDF = function(obj) {
	obj@coords
}
setMethod("coordinates", "SpatialPointsDataFrame", coordinates.SPDF)

"coordinates<-" = function(object, value) {
	if (inherits(value, "formula"))
		value = model.frame(value, object) # retrieve
	else if (is.character(value))
		value = object[, value] # retrieve
	else if (is.null(dim(value)) && length(value) > 1) { # coord.columns?
		if (any(value != as.integer(value) || any(value < 1)))
			stop("coordinate columns should be positive integers")
		value = object[, value] # retrieve
	} else 
		value = coordinates(value)
	if (is.null(object))
		SpatialPoints(coords = value)
	else
		SpatialPointsDataFrame(data = object, coords = as.matrix(value))
}

#"coordinates<-" = coordinates.replacedf
#setReplaceMethod("coordinates", signature(object = "data.frame"), 
#	coordinates.replacedf
#)

## print.Sp... uses S3 method dispatch, but can pass the ... arguments
print.SpatialPointsDataFrame = function(x, ...) {
  cc = substring(paste(as.data.frame(t(signif(coordinates(x))))),2,999)
  # could be done in S-Plus by unpaste(x, "c")[[2]]
  print(data.frame("coordinates" = cc, x@data), ...)
}
dim.SpatialPointsDataFrame = function(x) dim(x@data)

#ifdef R
setAs("SpatialPointsDataFrame", "data.frame", function(from) { from@data })
#else
#%setAs("SpatialPointsDataFrame", "data.frame", function(object) { object@data })
#endif

as.data.frame.SpatialPointsDataFrame = function(x, row.names, optional) 
	as(x, "data.frame")

ShowSpatialPointsDataFrame = function(object) print.SpatialPointsDataFrame(object)
setMethod("show", "SpatialPointsDataFrame", ShowSpatialPointsDataFrame)

plot.SpatialPointsDataFrame = function(x, ...) {
	plot(x@coords[,1], x@coords[,2], ...)
}

summary.SpatialPointsDataFrame = function(object, ...) {
    obj = list()
	obj[["data"]] = summary(object@data)
	obj[["coords"]] = summary(object@coords)
    class(obj) = "summary.SpatialPointsDataFrame"
    obj
}

print.summary.SpatialPointsDataFrame = function(x, ...) {
	cat("attribute table data:\n")
	print(x$data)
	cat("Coordinates:\n")
	print(x$coords)
	cat("\n")
}

# try to get "[.data.frame" behaviour, but _always_ preserve columns,
# if needed add them
#ifdef R
setMethod("[", "SpatialPointsDataFrame", function(x, i, j, ..., drop = FALSE) {
		missing.i = missing(i)
		missing.j = missing(j)
#else
#%setMethod("[", "SpatialPointsDataFrame", function(x, ..., drop = T) {
#%		missing.i = missing.j = F
#%		ndots = nDotArgs(...)
#%		if (ndots < 1)
#%			return(x)
#%		if (missing(drop))
#%			drop = F
#%		else
#%			stop("do not specify drop, it is assumed FALSE anyway")
#%		args = match.call(function(x, i, j, drop){})
#%		if (!is.null(args$i)) {
#%			i = eval(args$i, sys.parent(1))
#%			if (is.null(i))
#%				missing.i = T
#%		} else 
#%			missing.i = TRUE
#%		if (!is.null(args$j)) {
#%			j = eval(args$j, sys.parent(1))
#%			if (is.null(j))
#%				missing.j = T
#%		} else 
#%			missing.j = T
#endif
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
			stop("matrix argument not supported in SpatialPointsDataFrame selection")

		SpatialPointsDataFrame(coords = x@coords[i, , drop=FALSE],
			data = x@data[i, j, drop = FALSE])
	}
)
