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

tor.shift <- function(pts,xsh,ysh,rect)
{
	if(missing(rect))rect <- bbox(pts)
	
	xoff <- min(rect[,1])
	yoff <- min(rect[,2])
	
	xsc <- (max(rect[,1])-xoff)
	ysc <- (max(rect[,2])-yoff)
	
	pts[,1] <- pts[,1]-xoff
	pts[,2] <- pts[,2]-yoff
	pts <- shift(pts,xsh,ysh)
	pts[,1] <- (pts[,1] %% xsc )+xoff
	pts[,2] <- (pts[,2] %% ysc )+yoff
	pts
}
