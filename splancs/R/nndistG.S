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

