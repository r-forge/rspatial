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

stkhat <- function(pts, times, poly, tlimits, s, tm)
{
#	mathlib.dynam('splancs','stkhat.o')
# space-time khat function
	tlow <- min(tlimits)
	thigh <- max(tlimits)
	s <- sort(s)
	ns <- length(s)
	tm <- sort(tm)
	nt <- length(tm)
	x1 <- pts[, 1]
	y1 <- pts[, 2]
	t1 <- times
	n1 <- length(x1)
	nc <- npts(poly)
	xc <- c(poly[, 1], poly[1, 1])
	yc <- c(poly[, 2], poly[1, 2])
	hs <- rep(0, ns)
	ht <- rep(0, nt)
	hst <- matrix(0, ns, nt)
	storage.mode(hst) <- "double"
	ktlist <- .Fortran("stkhat",
		as.double(x1),
		as.double(y1),
		as.double(t1),
		as.integer(n1),
		as.double(xc),
		as.double(yc),
		as.integer(nc),
		as.double(s),
		as.integer(ns),
		as.double(tm),
		as.integer(nt),
		as.double(tlow),
		as.double(thigh),
		hs = as.double(hs),
		ht = as.double(ht),
		hst = (hst))

	list(s=s,t=tm,ks = ktlist$hs, kt = ktlist$ht, kst = ktlist$hst)
}
