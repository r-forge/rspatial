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

zoom <- function(quiet=F,out=F,...)
{
	if(!out){
		if(!quiet){
			cat("Enter 2 points as corners of zoom area\n")
		}
		pointmap(bbox(as.points(locator(2,type="l"))),type="n",...)
	}
	if(out){
		usr <- par()$usr
		xwidth <- usr[2]-usr[1]
		ywidth <- usr[4]-usr[3]
		xmin <- usr[1]-xwidth
		xmax <- usr[2]+xwidth
		ymin <- usr[3]-ywidth
		ymax <- usr[4]+ywidth
		pointmap(cbind(c(xmin,xmax),c(ymin,ymax)),type='n')
	}
	invisible(0)
}

