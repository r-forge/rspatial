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

spoints <- function(data,npoints)
{
	ldat <- length(data)
	if(missing(npoints)){
		if(ldat%%2 != 0){
			warning("Odd number of data items")
			warning("last one will be ignored")
			ldat <- ldat-1
			data <- data[1:ldat]
		}
		npoints <- ldat/2
	}
	else{
		if(ldat < npoints*2){
			data <- rep(data,length.out=npoints*2)
		}
		else{
			data <- data[1:(npoints*2)]
		}
	}
	matrix(data,ncol=2,byrow=T)	
}

	
	
