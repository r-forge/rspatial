area <- function(poly)
{
#	library.dynam("splancs","areapl.o")

	np <- length(poly[,1])

	polyx <- c(poly[,1],poly[1,1])
	polyy <- c(poly[,2],poly[1,2])
	
	answer <- 0

	alist <- .Fortran(	"areapl",
			as.double(polyx),
			as.double(polyy),
			as.integer(np),
			as.double(answer)
			)
	alist[[4]]	
	
}
