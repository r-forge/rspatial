# Lancaster, Thu Nov  4 14:44:00 GMT 2004, fresh start from icelfloe
setClass("Spatial",
	representation(bbox = "matrix",
		proj4string = "CRS"),
	prototype = list(
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA))), # will not prove valid; ignore
	validity = function(object) {
		if (!is.matrix(object@bbox))
			return("bbox should be a matrix")
		n = dimensions(object)
		# may be relaxed later on:
		if (n > 3 || n < 2)
			return("spatial.dimension should be either 2 or 3") 
		if (any(is.na(object@bbox)))
			return("bbox x and y values should never be NA")
		if (any(object@bbox[,"max"] < object@bbox[,"min"]))
			return("bbox is invalid: max < min")
		if (!is(object@proj4string, "CRS"))
			return("proj4string should be CRS")
		# validate proj4string here
		return(TRUE)
	}
)

