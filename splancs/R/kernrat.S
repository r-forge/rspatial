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

kernrat <- function(pts1,pts2,poly,h1,h2,nx=20,ny=20,kernel='quartic')
{
	kern1 <- kernel2d(pts1,poly,h1,nx,ny,kernel)
	kern2 <- kernel2d(pts2,poly,h2,nx,ny,kernel)
	
	list(x=kern1$x,y=kern1$y,z=kern1$z/kern2$z,h=c(h1,h2),kernel=kernel)
}


	
	
