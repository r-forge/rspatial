# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2001 by Roger S. Bivand
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

inout <- function(pts, poly, bound=NULL)
{
#	library.dynam("splancs", "inpip.o")
	np <- length(poly[, 1])
	xp <- c(poly[, 1], poly[1, 1])
	yp <- c(poly[, 2], poly[1, 2])
	nptsi <- npts(pts)
	ind <- seq(T, length = nptsi)
	piplist <- .Fortran("inpip",
		as.double(pts[, 1]),
		as.double(pts[, 2]),
		as.integer(nptsi),
		as.double(xp),
		as.double(yp),
		as.integer(np),
		as.logical(ind))
#
# sets in-polygon criterion for points precisely equal to polygon
# vertices (suggestion by Rainer Hurling <rhurlin@gwdg.de>)
# better fix to follow for points on polygon boundary
#
	if(!is.null(bound)){
        	if(!is.logical(bound))
			stop("bound must be NULL, TRUE, or FALSE")
        	cpts <- complex(real=pts[, 1], imag=pts[, 2])
        	cpoly <- complex(real=xp, imag=yp)
        	bound.pts <- which(cpts %in% cpoly)
        	piplist[[7]][bound.pts] <- bound
	}
	piplist[[7]]
}
