k12hat <- function(pts1,pts2,poly, s)
{
	mathlib.dynam("splancs","k12hat.o")
	ptsx1_pts1[,1]
	ptsy1_pts1[,2]
	npt1_npts(pts1)
	ptsx2_pts2[,1]
	ptsy2_pts2[,2]
	npt2_npts(pts2)

	ns_length(s)
	s_sort(s)

	np_length(poly[,1])
	polyx_c(poly[,1],poly[1,1])
	polyy_c(poly[,2],poly[1,2])

	h12_rep(0,times=ns)
	h21_h12

	klist_.Fortran("k12hat",
		as.double(ptsx1),
		as.double(ptsy1),
		as.integer(npt1),
		as.double(ptsx2),
		as.double(ptsy2),
		as.integer(npt2),
		as.double(polyx),
		as.double(polyy),
		as.integer(np),
		as.double(s),
		as.integer(ns),
		as.double(h12),
		as.double(h21))
	klist[[12]]
}
