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

mse2d <- function(pts,poly,nsmse,range)
{
#	library.dynam("splancs","twodimmse.o")
	ptsx <- pts[,1]
	ptsy <- pts[,2]
	nptsm <- npts(pts)
	
	a1 <- min(poly[,1],na.rm=T)
	a2 <- max(poly[,1],na.rm=T)
	b1 <- min(poly[,2],na.rm=T)
	b2 <- max(poly[,2],na.rm=T)
	
	hsmse <- range/nsmse
	amse <- rep(0,nsmse)
	t <- rep(0,nsmse)
	
	mselist <- .Fortran("mse2d",
		as.double(ptsx),
		as.double(ptsy),
		as.integer(nptsm),
		as.double(a1),
		as.double(a2),
		as.double(b1),
		as.double(b2),
		as.integer(nsmse),
		as.double(hsmse),
		as.double(amse),
		as.double(t)
		)
		
	list(mse=mselist[[10]],h=mselist[[11]])
}
