gridpts <- function(poly,npts,xs,ys)
{
	bb <- bbox(poly)
	
	if(!missing(npts))
	{
		areap <- areapl(poly)
		areab <- areapl(bb)
		ratio <- areab/areap
		ngen <- npts*ratio
		nx <- sqrt(ngen)
		ny <- sqrt(ngen)
		xs <- (diff(range(bb[,1])))/nx
		ys <- (diff(range(bb[,2])))/ny
	}
	xc <- seq(from=min(bb[,1])-(xs/2),to=max(bb[,1])+(xs/2),by=xs)
	yc <- seq(from=min(bb[,2])-(ys/2),to=max(bb[,2])+(ys/2),by=ys)
		
	nx <- length(xc)
	ny <- length(yc)
	npts <- nx*ny
	
	xy <- matrix(c(xc[(0:(npts-1))%%nx+1],yc[(0:(npts-1))%/%nx+1]),ncol=2)
	pip(xy,poly)
}

