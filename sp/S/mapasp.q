mapasp <- function(data) {
	# calculates aspect ratio for levelplot of geographic data,
	# using proportial units (compare eqscplot)
	if (!extends(class(data), "SpatialData"))
		stop("cannot extract coordinates from data")
	diff(data@bbox[2,])/diff(data@bbox[1,])
}
