mpoint <- function(...,cpch,add=F,type="p")
{
	arglist <- list(...)

	nptsets <- length(arglist)
	if(missing(cpch)){
		alphanum <- c(as.character(1:9),LETTERS)
		cpch <- alphanum[1:nptsets]
		}
	cpch <- rep(cpch,length=nptsets)
	ipch <- 1
	xmax <- NA;ymax <- NA;xmin <- NA;ymin <- NA
	if(add==F){
		
		for(ia in 1:nptsets){
			if(is.points(arglist[[ia]]))
			{
				ptsc <- arglist[[ia]]
				ymax <- max(ymax,ptsc[,2],na.rm=T)
				ymin <- min(ymin,ptsc[,2],na.rm=T)
				xmax <- max(xmax,ptsc[,1],na.rm=T)
				xmin <- min(xmin,ptsc[,1],na.rm=T)
			}
		}
		pointmap(cbind(c(xmin,xmax,xmin,xmax),c(ymin,ymax,ymax,ymin)),type="n")
	}	
	for(ia in 1:nptsets){
		ptsc <- arglist[[ia]]
		pointmap(ptsc,add=T,pch=cpch[ipch],type=type)
		ipch <- ipch+1
	}
	invisible(0)
}	
