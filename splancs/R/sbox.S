sbox <- function(pts,xfrac=.1,yfrac=.1)
{
	if(!is.points(pts))stop('Points argument not valid point data')
	
	xr <- range(pts[,1],na.rm=T)
	yr <- range(pts[,2],na.rm=T)
	
	xw <- xr[2]-xr[1]
	xr[1] <- xr[1]-xfrac*xw
	xr[2] <- xr[2]+xfrac*xw

	yw <- yr[2]-yr[1]
	yr[1] <- yr[1]-yfrac*yw
	yr[2] <- yr[2]+yfrac*yw
	
	cbind(c(xr[1], xr[2], xr[2], xr[1]), c(yr[1], yr[1], yr[2], yr[2]))
}

