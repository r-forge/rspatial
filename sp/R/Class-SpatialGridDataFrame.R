setClass("SpatialGridDataFrame",
	representation("SpatialGrid", data = "data.frame", coords.nrs = "numeric"),
	validity = function(object) {
		if (length(object@grid.index) > 0) {
			if (nrow(object@coords) != nrow(object@data))
				stop("unequal number of objects in points and data.frame")
		} else {
			if (.NumberOfCells(object@grid) != nrow(object@data))
				stop("unequal number of objects in full grid and data.frame")
		}
		return(TRUE)
	}
)
