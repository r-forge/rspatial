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

Kenv.tor <- function(pts1,pts2,poly,nsim,s,quiet=F)
{
	rect <- bbox(poly)
	kmax <- rep(0, length = length(s))
	kmin <- rep(9.999999999999999e+33, length = length(s))
	for(isim in 1:nsim){
		if(!quiet)cat("Doing shift ", isim, "/", nsim, "\n")
		pts2 <- rtor.shift(pts2,rect)
		k12sim <- k12hat(pts1,pts2,poly,s)
		kmax <- pmax(kmax,k12sim)
		kmin <- pmin(kmin,k12sim)
	}
	list(lower=kmin,upper=kmax)
}
