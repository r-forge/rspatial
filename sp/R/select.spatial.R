"select.spatial" <- function(data, digitize = TRUE, pch = "+") {
	if (!extends(class(data), "SpatialDataFrame"))
		stop("data should be of, or extend, class SpatialDataFrame")
	cc = coordinates(data)
	x = cc[, 1]
	y = cc[, 2]
	plot(x, y, pch = pch, asp = 1)
	if (digitize) {
		pol = locator(n = 512, type = "o")
		sel = 1:nrow(cc)
		sel[point.in.polygon(x, y, pol$x, pol$y) > 0]
	} else
		identify(x, y, labels = row.names(data))
}
