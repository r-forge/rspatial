nndistF <- function(pts1,pts2)
{
	library.dynam("splancs","nndist.o")
	npts1_npts(pts1)
	npts2_npts(pts2)

# reserve an array for the result
	dists_rep(0,npts2)

	nnlist_.Fortran("nndisf",as.double(pts1[,1]),
				 as.double(pts1[,2]),
	                         as.integer(npts1),
	                         as.double(pts2[,1]),
	                         as.double(pts2[,2]),
	                         as.integer(npts2),
	                         as.double(dists))
	nnlist[[7]]
}


