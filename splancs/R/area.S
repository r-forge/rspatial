area <- function(poly)
{
	library.dynam("splancs","areapl.o")

	np_length(poly[,1])

	polyx_c(poly[,1],poly[1,1])
	polyy_c(poly[,2],poly[1,2])
	
	answer_0

	alist_.Fortran(	"areapl",
			as.double(polyx),
			as.double(polyy),
			as.integer(np),
			as.double(answer)
			)
	alist[[4]]	
	
}
