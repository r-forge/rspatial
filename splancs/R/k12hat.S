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

k12hat <- function(pts1,pts2,poly, s)
{
#	mathlib.dynam("splancs","k12hat.o")
	ptsx1 <- pts1[,1]
	ptsy1 <- pts1[,2]
	npt1 <- npts(pts1)
	ptsx2 <- pts2[,1]
	ptsy2 <- pts2[,2]
	npt2 <- npts(pts2)

	ns <- length(s)
	s <- sort(s)

	np <- length(poly[,1])
	polyx <- c(poly[,1],poly[1,1])
	polyy <- c(poly[,2],poly[1,2])

	h12 <- rep(0,times=ns)
	h21 <- h12

	klist <- .Fortran("k12hat",
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
