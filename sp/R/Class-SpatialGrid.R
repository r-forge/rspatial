setClass("SpatialGrid", 
	representation("SpatialPoints", grid = "GridTopology", grid.index = "integer"),
	validity = function(object) {
		# check that dimensions, proj4string and bbox do not conflict
		if (length(object@grid.index) > 0 && 
				nrow(object@coords) != length(object@grid.index))
			stop("with coords, grid.index should have length equal to nrow(coords)")
		return(TRUE)
	}
)

