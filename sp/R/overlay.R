overlayPointsWithRings = function(x, y, fn = NULL) {
	# x = pts, y = rings, return ring with f(grid) items
	y = as(y, "SpatialRings")
	id = pointsInSpatialRings(x, y)
	if (!is.null(fn)) {
		df = as(x, "data.frame")
		data.frame(t(data.frame(lapply(split(df, id), fn))))
	} else
		id
}

setMethod("overlay", 
	signature(x = "SpatialPointsDataFrame", y = "SpatialRings"), 
		 overlayPointsWithRings)

setMethod("overlay", 
	signature(x = "SpatialPoints", y = "SpatialRings"), 
	function(x, y, ...) overlayPointsWithRings(x, y))  # no fn argument!

overlayRingsWithPoints = function(x, y, ...) {
	# x = rings, y = pts; return pts with ring values (or id) at grid point
	ypts = as(y, "SpatialPoints")
	sr = as(x, "SpatialRings")
	id = pointsInSpatialRings(ypts, sr)
	if (is(x, "SpatialRingsDataFrame")) {
		ret = x@data[id, , drop = FALSE]
		if (is(y, "SpatialPointsDataFrame"))
			row.names(ret) = row.names(as(y, "data.frame"))
		return(ret)
	} else
		return(id) # 
}

setMethod("overlay", signature("SpatialRings", "SpatialPoints"), 
	overlayRingsWithPoints)
