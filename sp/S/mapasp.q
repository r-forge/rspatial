mapasp <- function(data) {
	# calculates aspect ratio for levelplot of geographic data,
	# using proportial units (compare eqscplot)
	if (!extends(class(data), "SpatialData"))
		stop("cannot extract coordinates from data")
#ifdef R
	# in R >= 2.0.0, lattice accepts "iso":
	if (version$major >= 2)
		"iso"
	else
		diff(data@bbox[2,])/diff(data@bbox[1,])
#else
	diff(data@bbox[2,])/diff(data@bbox[1,])
#endif
}
