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

Kenv.label <- function(pts1,pts2,poly,nsim,s,quiet=F)
{
	kmax <- rep(0,length=length(s))
	kmin <- rep(1.0E34,length=length(s))
	
	for(isim in (1:nsim)){
		if(!quiet)cat('Doing labelling ',isim,'/',nsim,'\n')
		labpts <- rlabel(pts1,pts2)
		k1sim <- khat(labpts[[1]],poly,s)
		k2sim <- khat(labpts[[2]],poly,s)
		diffk <- k1sim-k2sim
		kmax <- pmax(kmax,diffk)
		kmin <- pmin(kmin,diffk)
	}
	list(lower=kmin,upper=kmax)
}

