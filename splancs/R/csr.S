csr <- function(poly,nptg)
{
	ranpts(NULL,poly,nptg)[1:nptg,]
}

ranpts <- function(pts,poly,nprq)
{
# recursively keep generating points until we have more than enough...
#	cat("generating ",nprq," points\n")
	genpts <- gen(poly,nprq)
	npgen <- length(genpts)/2
#	cat("generated ",npgen," points\n")
	if(npgen != 0)pts <- rbind(pts,genpts)
	if (npgen < nprq)
	{
		pts <- ranpts(pts,poly,nprq-npgen)
	}
	pts
}

gen <- function(poly,nptg)
{
	areap <- areapl(poly)
	areab <- areapl(bbox(poly))

	xmin <- min(poly[,1],na.rm=T)
	xmax <- max(poly[,1],na.rm=T)
	ymin <- min(poly[,2],na.rm=T)
	ymax <- max(poly[,2],na.rm=T)

	aratio <- areab/areap
	ngen <- nptg*aratio
	
	xc <- xmin+runif(ngen)*(xmax-xmin)
	yc <- ymin+runif(ngen)*(ymax-ymin)
	
	xy <- cbind(xc,yc)
	pip(xy,poly)
	
}
