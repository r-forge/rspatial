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

khat <- function(pts,poly, s)
{
#	mathlib.dynam("splancs","dokhat.o")
	ptsx <- pts[,1]
	ptsy <- pts[,2]
	npt <- npts(pts)

	ns <- length(s)
	s <- sort(s)

	np <- length(poly[,1])
	polyx <- c(poly[,1],poly[1,1])
	polyy <- c(poly[,2],poly[1,2])

	hkhat <- rep(0,times=ns)

	klist <- .Fortran("dokhat",
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
