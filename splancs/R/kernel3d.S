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

"kernel3d"<-
function(pts,times, xgr, ygr, zgr, hxy, hz)
{

#        library.dynam('splancs','kernel3d.o')
        pts3 <- cbind(pts,times)
	nx <- length(xgr)
	ny <- length(ygr)
	nz <- length(zgr)
	mat3 <- array(data = 0, dim = c(nx, ny, nz))
	storage.mode(mat3) <- "double"
	ans <- .Fortran("kern3d",
		as.double(pts3[, 1]),
		as.double(pts3[, 2]),
		as.double(pts3[, 3]),
		as.integer(length(pts3[, 3])),
		as.double(xgr),
		as.integer(length(xgr)),
		as.double(ygr),
		as.integer(length(ygr)),
		as.double(zgr),
		as.integer(length(zgr)),
		as.double(hxy),
		as.double(hz),
		kernarr = mat3)
	list(xgr = xgr, ygr = ygr, zgr = zgr, hxy = hxy, hz = hz, v = ans$
		kernarr)
}


# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
