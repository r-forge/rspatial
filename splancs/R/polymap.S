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

polymap <- function(poly,add=F,xlab="",ylab="",axes=T,...)
{
#	pty.old <- par("pty")
#	if(pty.old!='s')warning('polymap: plot type not square.')
	if(!add){
		xrnge <- range(poly[, 1],na.rm=T)
		yrnge <- range(poly[, 2],na.rm=T)
		xd <- xrnge[2]-xrnge[1]
		yd <- yrnge[2]-yrnge[1]
		if(xd > yd) {
			xplot <- xrnge
                        yplot <- NULL
                        yplot[1] <- ((yrnge[2] + yrnge[1])/2) - xd/2
                        yplot[2] <- ((yrnge[2] + yrnge[1])/2) + xd/2
               		}
                else {
                        yplot <- yrnge
                        xplot <- NULL
                        xplot[1] <- ((xrnge[2] + xrnge[1])/2) - yd/2
                        xplot[2] <- ((xrnge[2] + xrnge[1])/2) + yd/2
			}
#	par(pty="s")
	plot(poly,xlim=xplot,ylim=yplot,type="n",axes=axes,xlab=xlab,ylab=ylab)
	}

#	polygon(poly,density=0,...)
	polygon(poly,...)
#	par("pty"=pty.old)
	invisible(0)
}



