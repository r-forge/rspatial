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

delpoints <- function(pts,add=F)
{
	if(!add)pointmap(pts)
	cat("Use button 1 to delete points - button 2 when finished.\n")
	deld <- identify(pts[,1],pts[,2],atpen=F,offset=0,labels=rep("X",length(pts[,1])))
	if(length(deld)!=0){
		pts <- pts[-deld,]
		}
	pts
}

