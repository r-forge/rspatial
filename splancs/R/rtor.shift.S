rtor.shift <- function(pts,rect)
{
	if(missing(rect))rect_bbox(pts)
	xsc_max(rect[,1])-min(rect[,1])
	ysc_max(rect[,2])-min(rect[,2])
	xsh_runif(1)*xsc
	ysh_runif(1)*ysc
	tor.shift(pts,xsh,ysh,rect)
}
