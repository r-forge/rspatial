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

mpoint <- function(...,cpch,add=F,type="p")
{
	arglist <- list(...)

	nptsets <- length(arglist)
	if(missing(cpch)){
		alphanum <- c(as.character(1:9),LETTERS)
		cpch <- alphanum[1:nptsets]
		}
	cpch <- rep(cpch,length=nptsets)
	ipch <- 1
	xmax <- NA;ymax <- NA;xmin <- NA;ymin <- NA
	if(add==F){
		
		for(ia in 1:nptsets){
			if(is.points(arglist[[ia]]))
			{
				ptsc <- arglist[[ia]]
				ymax <- max(ymax,ptsc[,2],na.rm=T)
				ymin <- min(ymin,ptsc[,2],na.rm=T)
				xmax <- max(xmax,ptsc[,1],na.rm=T)
				xmin <- min(xmin,ptsc[,1],na.rm=T)
			}
		}
		pointmap(cbind(c(xmin,xmax,xmin,xmax),c(ymin,ymax,ymax,ymin)),type="n")
	}	
	for(ia in 1:nptsets){
		ptsc <- arglist[[ia]]
		pointmap(ptsc,add=T,pch=cpch[ipch],type=type)
		ipch <- ipch+1
	}
	invisible(0)
}	
