"gridded<-" = function(obj, value) {
#	if (!extends(class(obj), "Spatial"))
#		stop("object should be of or extend class Spatial")
	if (is.logical(value)) {
		if (is(obj, "SpatialCellDataFrame")) {
			if (value == FALSE)
				return(SpatialPointsDataFrame(obj@coords, obj@data))
		} else if (is(obj, "SpatialCell")) {
			if (value == FALSE)
				return(as(obj, "SpatialPoints"))
		} else if (is(obj, "SpatialPointsDataFrame")) {
			if (value == TRUE)
				return(SpatialCellDataFrame(obj@coords, obj@data, obj@coords.nrs))
		} else if (is(obj, "SpatialPoints")) {
			if (value == TRUE)
				return(SpatialCell(obj))
		} else if (is(obj, "data.frame") && 
				(is(value, "formula") || is(value, "character"))) {
			coordinates(obj) = value
			gridded(obj) = TRUE
		}
	} else {
		if (is(value, "SpatialGridded"))
			return(SpatialGriddedDataFrame(value, data.frame(obj)))
		else
			stop(paste("cannot deal with value of class"), class(value))
		# further deal with more complex forms of value
	}
	obj
}

griddedfn = function(obj) { 
	return (extends(class(obj), "SpatialGridded") ||
		extends(class(obj), "SpatialCell")) 
}

setMethod("gridded", "Spatial", function(obj) griddedfn(obj))
