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

rtor.shift <- function(pts,rect)
{
	if(missing(rect))rect <- bbox(pts)
	xsc <- max(rect[,1])-min(rect[,1])
	ysc <- max(rect[,2])-min(rect[,2])
	xsh <- runif(1)*xsc
	ysh <- runif(1)*ysc
	tor.shift(pts,xsh,ysh,rect)
}
