khat <- function(pts,poly, s)
{
	mathlib.dynam("splancs","dokhat.o")
	ptsx_pts[,1]
	ptsy_pts[,2]
	npt_npts(pts)

	ns_length(s)
	s_sort(s)

	np_length(poly[,1])
	polyx_c(poly[,1],poly[1,1])
	polyy_c(poly[,2],poly[1,2])

	hkhat_rep(0,times=ns)

	klist_.Fortran("dokhat",
		as.double(ptsx),
		as.double(ptsy),
		as.integer(npt),
		as.double(polyx),
		as.double(polyy),
		as.integer(np),
		as.double(s),
		as.integer(ns),
		as.double(hkhat))
	klist[[9]]
}
