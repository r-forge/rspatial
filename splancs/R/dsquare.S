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

dsquare <- 
function(pts, srcs, namepref="d")
{
  ptsxy <- as.points(pts)
  nameso <- names(pts)
	d <- NULL
	nsrcs <- npts(srcs)
	for(i in 1:nsrcs) {
		d <- cbind(d, (srcs[i, 1] - ptsxy[,1])^2 + (srcs[i, 2] - 
			ptsxy[,2])^2)
		nameso <- c(nameso,paste(namepref,i,sep=''))
	}
	res <- as.data.frame(d)
        names(res) <- nameso
        res
}

# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
