rtor.shift <- function(pts,rect)
{
	if(missing(rect))rect <- bbox(pts)
	xsc <- max(rect[,1])-min(rect[,1])
	ysc <- max(rect[,2])-min(rect[,2])
	xsh <- runif(1)*xsc
	ysh <- runif(1)*ysc
	tor.shift(pts,xsh,ysh,rect)
}
