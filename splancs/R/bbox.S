bbox <- function(pts)
{
	if(!is.points(pts))stop('Points argument not valid point data')
	
	xr_range(pts[,1],na.rm=T)
	yr_range(pts[,2],na.rm=T)
	
	cbind(c(xr[1],xr[2],xr[2],xr[1]),c(yr[1],yr[1],yr[2],yr[2]))
}

 
