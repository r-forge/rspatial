nndistG <- function(pts)
{
#	library.dynam("splancs","nndist.o")
	nptsg <- npts(pts)
	neighs <- rep(0,nptsg)
	dists <- rep(0,nptsg)
	nnlist <- .Fortran("nndisg",as.double(t(pts[,1:2])),
	                         as.integer(nptsg),
	                         as.double(dists),
				 as.integer(neighs))
	list(dists=nnlist[[3]],neighs=nnlist[[4]])
}

