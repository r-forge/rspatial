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

as.points <- function(...)
{
	nv <- nargs()
	fargs <- list(...)
	if(nv==2){
		l1 <- length(fargs[[1]])
		l2 <- length(fargs[[2]])
		if(l1==l2){
			pts <- cbind(fargs[[1]],fargs[[2]])
		}
		else{
			stop("Cannot make points from different length vectors")
		}
		
	}
	else{
		if(nv==1){
			if(is.list(fargs[[1]])){
				fargs <- fargs[[1]]
				if(any(names(fargs)=="x") & any(names(fargs)=="y")){
					arx <- fargs$x
					ary <- fargs$y
					if(length(arx)!=length(ary)){
						stop("Cannot make points from different length x and y list components!")
					}
					else{
						pts <- cbind(arx,ary)
					}
				}
				else{
					stop("Cannot make points from list without x and y components.")
				}
			}
			else{
				if(is.points(fargs[[1]]))pts <- fargs[[1]]
				else stop("Cannot make points from this object")
			}
		
		}
		else{
			stop("Cannot make object into points!")
		}
	}

	pts
}
