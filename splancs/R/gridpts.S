gridpts <- function(poly,npts,xs,ys)
{
	bb_bbox(poly)
	
	if(!missing(npts))
	{
		areap_area(poly)
		areab_area(bb)
		ratio_areab/areap
		ngen_npts*ratio
		nx_sqrt(ngen)
		ny_sqrt(ngen)
		xs_(diff(range(bb[,1])))/nx
		ys_(diff(range(bb[,2])))/ny
	}
	xc_seq(from=min(bb[,1])-(xs/2),to=max(bb[,1])+(xs/2),by=xs)
	yc_seq(from=min(bb[,2])-(ys/2),to=max(bb[,2])+(ys/2),by=ys)
		
	nx_length(xc)
	ny_length(yc)
	npts_nx*ny
	
	xy_matrix(c(xc[(0:(npts-1))%%nx+1],yc[(0:(npts-1))%/%nx+1]),ncol=2)
	pip(xy,poly)
}

