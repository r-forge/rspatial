sbox <- function(pts,xfrac=.1,yfrac=.1)
{
	if(!is.points(pts))stop('Points argument not valid point data')
	
	xr_range(pts[,1],na.rm=T)
	yr_range(pts[,2],na.rm=T)
	
	xw_xr[2]-xr[1]
	xr[1]_xr[1]-xfrac*xw
	xr[2]_xr[2]+xfrac*xw

	yw_yr[2]-yr[1]
	yr[1]_yr[1]-yfrac*yw
	yr[2]_yr[2]+yfrac*yw
	
	cbind(c(xr[1], xr[2], xr[2], xr[1]), c(yr[1], yr[1], yr[2], yr[2]))
}

