setClass("Ring4",
	representation("Spatial",
		coords = "matrix",
		ringDir = "integer",
		region.id = "character",
		plotOrder = "integer"),
	prototype = list(
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		coords = matrix(0),
		ringDir = integer(0),
		region.id = character(0),
		plotOrder = integer(0)),
	validity = function(object) {
			if (ncol(object@coords) != 2)
				return("polygon should have 2 columns")
			return(TRUE)
		}
)

setClass("SpatialRings",
	representation("Spatial",
		polygons = "list",
		region.id = "character",
		plotOrder = "integer"),
	prototype = list(
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		polygons = list(), 
		region.id = character(0), 
		plotOrder = integer(0)),
	validity = function(object) {
		if (length(object@polygons) != length(object@region.id))
			return("length mismatch")
		if (length(object@polygons) != length(object@plotOrder))
			return("length mismatch")
		if (any(unlist(lapply(object@polygons, function(x) 
				!is(x, "Ring4"))))) 
			return("polygons not Ring4 objects")
		return(TRUE)
	}
)

