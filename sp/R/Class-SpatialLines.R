setClass("Sline", 
	representation("Spatial", coords = "matrix"),
	prototype = list(bbox = matrix(rep(NA, 6), 3, 2, 
			dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		coords = matrix(0)),
	validity = function(object) {
		if (any(is.na(object@coords)))
			stop("coords cannot contain missing values")
		if (ncol(object@coords) != 2)
			return("coords should have 2 columns")
		return(TRUE)
	}
)

setClass("SpatialLines",
	representation("Spatial", lines = "list"),
	prototype = list(bbox = matrix(rep(NA, 6), 3, 2, 
			dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		lines = list()),
	validity = function(object) {
		if (any(unlist(lapply(object@lines, function(x) 
			!is(x, "Sline"))))) stop("polygons not Sline objects")
		if (any(sapply(object@lines, function(x) 
			!identical(proj4string(object), proj4string(x))))) 
			stop("Different projections")
		return(TRUE)
	}
)

getSLlinesSlot <- function(SL) SL@lines

getSlineCoordsSlot <- function(Sline) Sline@coords

setMethod("coordinates", "Sline", function(obj) obj@coords)
setMethod("coordinates", "SpatialLines", function(obj) lapply(obj@lines, coordinates))
