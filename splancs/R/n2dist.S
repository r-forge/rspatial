# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#

n2dist <- function(pts1,pts2)
{
#	library.dynam("splancs","nndist.o")
	npts1 <- npts(pts1)
	npts2 <- npts(pts2)

# reserve arrays for the result
	dists <- rep(0,npts2)
	neighs <- rep(0,npts2)

	nnlist <- .Fortran("n2dist",as.double(pts1[,1]),
				 as.double(pts1[,2]),
	                         as.integer(npts1),
	                         as.double(pts2[,1]),
	                         as.double(pts2[,2]),
	                         as.integer(npts2),
	                         as.double(dists),
				as.integer(neighs))
	list(dists=nnlist[[7]],neighs=nnlist[[8]])
}


