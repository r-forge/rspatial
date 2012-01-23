setClass("SpatialPixels", 
	representation("SpatialPoints", grid = "GridTopology", grid.index = "integer"),
	validity = function(object) {
		if (nrow(object@coords) != length(object@grid.index))
			stop("grid.index should have length equal to nrow(coords)")
		return(TRUE)
	}
)

setClass("SpatialGrid",
	representation("Spatial", grid = "GridTopology"),
	validity = function(object) {
		return(TRUE)
	}
)
