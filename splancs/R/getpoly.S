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

getpoly <- function(quiet=F)
{
	if(!quiet){
		cat("Enter points with button 1\n")
		cat("Finish with button 2\n")
		cat("Don't try to join the polygon up - it is done for you.\n")
	}
	raw <- locator(type = "l")
	resloc <- cbind(raw$x, raw$y)
	lines(c(raw$x[1], raw$x[length(raw$x)]),
	      c(raw$y[1], raw$y[length(raw$y)]))
	resloc
}
