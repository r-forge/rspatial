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

plot.SpatialPoints = function(x, xlab, ylab, asp = 1, pch = 3, ...) 
{
	cc = coordinates(x)
	if (is.null(dimnames(cc)[[2]]))
		dimnames(cc)[[2]] = c("x", "y")
	nm = dimnames(cc)[[2]]
	if (missing(xlab))
		xlab = nm[1]
	if (missing(ylab))
		ylab = nm[2]
	# form = as.formula(paste(nm[2:1], collapse="~"))
	# plot(form, cc, asp = 1, ...) # should get names overridable?
	plot(cc[,1], cc[,2], xlab = xlab, ylab = ylab, asp = asp, pch = pch, ...)
}

setMethod("show", "SpatialPoints", function(object) print.SpatialPoints(object))
setMethod("coordinates", "SpatialPoints", function(obj) obj@coords)
setMethod("bbox", "SpatialPoints", function(obj) obj@bbox)
setMethod("dimensions", "SpatialPoints", function(obj) nrow(bbox(obj)))

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

subset.SpatialPoints <- function(x, subset, select, drop = FALSE, ...) {
	if (!missing(select) && (length(select) < 2)) 
		stop("selecting too few coordinate columns")
	res <- SpatialPoints(subset(coordinates(x), subset, select, 
		drop = drop))
	res
}

setMethod("[", "SpatialPoints", function(x, i, j, ..., drop = T)
	SpatialPoints(x@coords[i, , drop = FALSE]))

#setReplaceMethod("[", signature(x = "SpatialPoints"), 
#	function(x, ..., value) {
#		x@coords[...] = value
#		SpatialPoints(x@coords)
#	}
#)
