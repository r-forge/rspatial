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

Kenv.csr <- function(nptg,poly,nsim,s,quiet=F)
{
	kmax <- rep(0,length=length(s))
	kmin <- rep(1.0E34,length=length(s))
	
	for(isim in (1:nsim)){
		if(!quiet)cat('Doing simulation ',isim,'\n')
		khsim <- khat(csr(poly,nptg),poly,s)
		kmax <- pmax(kmax,khsim)
		kmin <- pmin(kmin,khsim)
	}
	list(lower=kmin,upper=kmax)
}
