setClass("SLine", 
	representation("Spatial", sline = "matrix"),
	validity = function(object) {
		if (any(is.na(object)))
			stop("lines cannot contain missing values")
		return(TRUE)
	}
)

setClass("SLines",
	representation("Spatial", slines = "SLine"),
	validity = function(object) {
		return(TRUE)
	}
)

setClass("SpatialLines",
	representation("Spatial", lines = "SLines"),
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
