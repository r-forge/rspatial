csr <- function(poly,nptg)
{
	ranpts(NULL,poly,nptg)[1:nptg,]
}

ranpts <- function(pts,poly,nprq)
{
# recursively keep generating points until we have more than enough...
#	cat("generating ",nprq," points\n")
	genpts_gen(poly,nprq)
	npgen_length(genpts)/2
#	cat("generated ",npgen," points\n")
	if(npgen != 0)pts_rbind(pts,genpts)
	if (npgen < nprq)
	{
		pts_ranpts(pts,poly,nprq-npgen)
	}
	pts
}

gen <- function(poly,nptg)
{
	areap_area(poly)
	areab_area(bbox(poly))

	xmin_min(poly[,1],na.rm=T)
	xmax_max(poly[,1],na.rm=T)
	ymin_min(poly[,2],na.rm=T)
	ymax_max(poly[,2],na.rm=T)

	aratio_areab/areap
	ngen_nptg*aratio
	
	xc_xmin+runif(ngen)*(xmax-xmin)
	yc_ymin+runif(ngen)*(ymax-ymin)
	
	xy_cbind(xc,yc)
	pip(xy,poly)
	
}
