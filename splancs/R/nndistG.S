# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand

nndistG <- function(pts)
{
#	library.dynam("splancs","nndist.o")
	nptsg <- npts(pts)
	neighs <- rep(0,nptsg)
	dists <- rep(0,nptsg)
	nnlist <- .Fortran("nndisg",as.double(t(pts[,1:2])),
	                         as.integer(nptsg),
	                         as.double(dists),
				 as.integer(neighs),
				PACKAGE="splancs")
	list(dists=nnlist[[3]],neighs=nnlist[[4]])
}

