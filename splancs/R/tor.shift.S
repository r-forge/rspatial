tor.shift <- function(pts,xsh,ysh,rect)
{
	if(missing(rect))rect_bbox(pts)
	
	xoff_min(rect[,1])
	yoff_min(rect[,2])
	
	xsc_(max(rect[,1])-xoff)
	ysc_(max(rect[,2])-yoff)
	
	pts[,1]_pts[,1]-xoff
	pts[,2]_pts[,2]-yoff
	pts_shift(pts,xsh,ysh)
	pts[,1]_(pts[,1] %% xsc )+xoff
	pts[,2]_(pts[,2] %% ysc )+yoff
	pts
}
