setClass("SpatialRingsDataFrame",
	representation("SpatialRings", data = "data.frame", 
		labelPoints = "ANY"),
	prototype = list(new("SpatialRings"), data = data.frame(),
		labelPoints = NULL),
	validity = function(object) {
		if (!inherits(object@data, "data.frame"))
			stop("data should be of class data.frame")
		if (nrow(object@data) != length(object@polygons))
		  stop("number of rows in data.frame and SpatialRings don't match")
		return(TRUE)
	}
)

