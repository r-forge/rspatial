# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand

nndistF <- function(pts1,pts2)
{
#	library.dynam("splancs","nndist.o")
	npts1 <- npts(pts1)
	npts2 <- npts(pts2)

# reserve an array for the result
	dists <- rep(0,npts2)

	nnlist <- .Fortran("nndisf",as.double(pts1[,1]),
				 as.double(pts1[,2]),
	                         as.integer(npts1),
	                         as.double(pts2[,1]),
	                         as.double(pts2[,2]),
	                         as.integer(npts2),
	                         as.double(dists),
				PACKAGE="splancs")
	nnlist[[7]]
}


