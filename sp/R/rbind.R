rbind.SpatialPoints <- function(...) {
	dots = list(...)
	SpatialPoints(do.call("rbind", lapply(list(...), coordinates)), CRS(proj4string(dots[[1]])))
}

rbind.SpatialPointsDataFrame <- function(...) {
	dots = list(...)
	sp = do.call("rbind", lapply(dots, function(x) as(x, "SpatialPoints")))
	df = do.call("rbind", lapply(dots, function(x) x@data))
	SpatialPointsDataFrame(sp, df, coords.nrs = dots[[1]]@coords.nrs)
}
