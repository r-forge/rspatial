n2dist <- function(pts1,pts2)
{
	library.dynam("splancs","nndist.o")
	npts1_npts(pts1)
	npts2_npts(pts2)

# reserve arrays for the result
	dists_rep(0,npts2)
	neighs_rep(0,npts2)

	nnlist_.Fortran("n2dist",as.double(pts1[,1]),
				 as.double(pts1[,2]),
	                         as.integer(npts1),
	                         as.double(pts2[,1]),
	                         as.double(pts2[,2]),
	                         as.integer(npts2),
	                         as.double(dists),
				as.integer(neighs))
	list(dists=nnlist[[7]],neighs=nnlist[[8]])
}


