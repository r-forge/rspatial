inout <- function(pts, poly)
{
#	library.dynam("splancs", "inpip.o")
	np <- length(poly[, 1])
	xp <- c(poly[, 1], poly[1, 1])
	yp <- c(poly[, 2], poly[1, 2])
	nptsi <- npts(pts)
	ind <- seq(T, length = nptsi)
	piplist <- .Fortran("inpip",
		as.double(pts[, 1]),
		as.double(pts[, 2]),
		as.integer(nptsi),
		as.double(xp),
		as.double(yp),
		as.integer(np),
		as.logical(ind))
	piplist[[7]]
}
