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

inout <- function (pts, poly, bound = NULL, quiet=TRUE) 
{
    xp <- c(poly[, 1], poly[1, 1])
    yp <- c(poly[, 2], poly[1, 2])
    np <- length(xp)
    nptsi <- npts(pts)
    ind <- logical(length = nptsi)
    if (!is.null(bound)) {
#
# sets in-polygon criterion for points equal to polygon
# boundaries (suggestion by Rainer Hurling <rhurlin@gwdg.de>)
#
	   if (!is.logical(bound)) 
		   stop("bound must be NULL, TRUE, or FALSE")
	   result <- integer(length=nptsi)
	   bb <- as.vector(apply(sbox(as.points(xp, yp)), 2, range))
	   za <- .C("ptinpoly1", as.integer(result), as.double(pts[, 1]),
		as.double(pts[, 2]), as.double(xp), as.double(yp),
		as.integer(np), as.double(bb), as.integer(nptsi))

	   z <- ind
	   if (!quiet) {
	       bpts <- which(za[[1]] == 0)
	       if (length(bpts > 0)) {
	           cat("Points on boundary:\n")
	           print(bpts)
	       }
	       else cat("No points on boundary\n")
	   }
	   if(bound) z[which(za[[1]] <= 0)] <- TRUE
	   else z[which(za[[1]] < 0)] <- TRUE
    } else {
        piplist <- .Fortran("inpip", as.double(pts[, 1]), as.double(pts[,2]), 
            as.integer(nptsi), as.double(xp), as.double(yp), 
            as.integer(np), as.logical(ind))
        z <- piplist[[7]]
    }
    z
}

