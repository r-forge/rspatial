setClass("SpatialPointsDataFrame",
	representation("SpatialPoints", data = "data.frame", coords.nrs = "numeric"),
	prototype = list(new("SpatialPoints"), data = data.frame(), 
		coords.nrs = numeric(0)),
	validity = function(object) {
		if (!inherits(object@data, "data.frame"))
			stop("data should be of class data.frame")
		if (nrow(object@coords) < 1)
			stop("no points set: too few rows")
		if (ncol(object@coords) <= 1)
			stop("no points set: too few columns")
		if (ncol(object@data) == 0)
			stop("data.frame is empty (possibly after stripping coordinate columns): use SpatialPoints() to create points-only object")
		if (nrow(object@data) != nrow(object@coords))
		  stop("number of rows in data.frame and SpatialPoints don't match")
		return(TRUE)
	}
)

"SpatialPointsDataFrame" = function(coords, data, coords.nrs = numeric(0)) {
	new("SpatialPointsDataFrame", SpatialPoints(coords), data = data,
		coords.nrs = coords.nrs)
}

coordinates.SPDF = function(obj) {
	obj@coords
}
setMethod("coordinates", "SpatialPointsDataFrame", coordinates.SPDF)

"coordinates<-" = function(object, value) {
	coord.numbers = NULL
	if (inherits(value, "formula")) {
		cc = model.frame(value, object) # retrieve coords
		if (dim(cc)[2] == 2) {
			nm = as.character(as.list(value)[[2]])[2:3]
			coord.numbers = match(nm, names(object))
		} else if (dim(cc)[2] == 3) {
			nm = c(as.character(as.list((as.list(value)[[2]])[2])[[1]])[2:3],
				as.character(as.list(value)[[2]])[3])
			coord.numbers = match(nm, names(object))
		} # else: give up.
	} else if (is.character(value)) {
		cc = object[, value] # retrieve coords
		coord.numbers = match(value, names(object))
	} else if (is.null(dim(value)) && length(value) > 1) { # coord.columns?
		if (any(value != as.integer(value) || any(value < 1)))
			stop("coordinate columns should be positive integers")
		cc = object[, value] # retrieve coords
		coord.numbers = value
	} else  # raw coordinates given; try transform them to matrix:
		cc = coordinates(value)
	if (!is.null(coord.numbers)) {
		object = object[ , -coord.numbers, drop = FALSE]
		stripped = coord.numbers
		# ... but as.data.frame(x) will merge them back in, so nothing gets lost.
	} else
		stripped = numeric(0)
	SpatialPointsDataFrame(data = object, coords = cc, coords.nrs = stripped)
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
setAs("SpatialPointsDataFrame", "data.frame", function(from) { 
	if (length(from@coords.nrs) > 0) {
		nc = dim(from@coords)[2]
		nd = dim(from@data)[2]
		nm = character(nc+nd)
		ret = list()
		for (i in 1:nc)
			ret[[from@coords.nrs[i]]] = from@coords[,i]
		nm[from@coords.nrs] = dimnames(from@coords)[[2]]
		idx.new = (1:(nc+nd))[-(from@coords.nrs)]
		for (i in 1:nd)
			ret[[idx.new[i]]] = from@data[,i]
		nm[idx.new] = names(from@data)
		names(ret) = nm
		data.frame(ret)
	} else
		from@data 
})
#else
#%setAs("SpatialPointsDataFrame", "data.frame", function(object) { object@data })
#endif

as.data.frame.SpatialPointsDataFrame = function(x, row.names, optional) 
	as(x, "data.frame")

ShowSpatialPointsDataFrame = function(object) print.SpatialPointsDataFrame(object)
setMethod("show", "SpatialPointsDataFrame", ShowSpatialPointsDataFrame)

plot.SpatialPointsDataFrame = function(x, ...) {
	plot(as(x, "SpatialPoints"), ...)
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
			data = x@data[i, j, drop = FALSE], coords.nrs = x@coords.nrs)
	}
)
