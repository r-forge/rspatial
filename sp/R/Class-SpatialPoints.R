setClass("SpatialPoints",
	representation("Spatial", coords = "matrix"),
	prototype = list(coords = matrix(0)),
	validity = function(object) {
		if (!is.matrix(object@coords))
			stop("coords slot is not a matrix")
		if (length(object@coords) == 0)
			stop("coords can not have length zero")
		if (nrow(object@coords) < 1)
			stop("no points set: too few rows")
		if (ncol(object@coords) <= 1)
			stop("no points set: too few columns")
		return(TRUE)
	}
)

"SpatialPoints" = function(coords) {
	coords = coordinates(coords)
	if (mode(coords) != "numeric")
		stop("coordinates should have mode numeric; try a cast with as.numeric")
	bbox = t(apply(coords, 2, range))
	dimnames(bbox)[[2]] = c("min", "max")
	new("SpatialPoints", coords = coords, bbox = as.matrix(bbox)) # transpose bbox?
}

setMethod("coordinates", "list", function(obj) as.matrix(as.data.frame(obj)))
setMethod("coordinates", "data.frame", function(obj) as.matrix(obj))
setMethod("coordinates", "matrix", function(obj) obj)

"print.SpatialPoints" <- function(x, ...)
{
	cat("SpatialPoints:\n")
	print(x@coords)
}

plot.SpatialPoints = function(x, ...) 
{
	plot(x@coords[,1], x@coords[,2], ...)
}

setMethod("show", "SpatialPoints", function(object) print.SpatialPoints(object))
setMethod("coordinates", "SpatialPoints", function(obj) obj@coords)

# no, use plot.SpatialPoints
# setMethod("plot", "SpatialPoints", 
#  function(object) plot(object@coords[,1], object@coords[,2]))

setAs("SpatialPoints", "data.frame", function(from) from@data)
as.data.frame.SpatialPoints = function(x, row.names, optional) {
    as(x, "data.frame")
}

setAs("data.frame", "SpatialPoints", function(from) { 
	SpatialPoints(coords = as.matrix(from))
})

setAs("matrix", "SpatialPoints", function(from) {
	SpatialPoints(coords = from)
})

setMethod("[", "SpatialPoints", function(x, i, j, ..., drop = T)
	SpatialPoints(x@coords[i, ]))

#setReplaceMethod("[", signature(x = "SpatialPoints"), 
#	function(x, ..., value) {
#		x@coords[...] = value
#		SpatialPoints(x@coords)
#	}
#)
