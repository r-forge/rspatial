mpoint <- function(...,cpch,add=F,type="p")
{
	arglist_list(...)

	nptsets_length(arglist)
	if(missing(cpch)){
		alphanum_c(as.character(1:9),LETTERS)
		cpch_alphanum[1:nptsets]
		}
	cpch_rep(cpch,length=nptsets)
	ipch_1
	xmax_NA;ymax_NA;xmin_NA;ymin_NA
	if(add==F){
		
		for(ia in 1:nptsets){
			if(is.points(arglist[[ia]]))
			{
				ptsc_arglist[[ia]]
				ymax_max(ymax,ptsc[,2],na.rm=T)
				ymin_min(ymin,ptsc[,2],na.rm=T)
				xmax_max(xmax,ptsc[,1],na.rm=T)
				xmin_min(xmin,ptsc[,1],na.rm=T)
			}
		}
		pointmap(cbind(c(xmin,xmax,xmin,xmax),c(ymin,ymax,ymax,ymin)),type="n")
	}	
	for(ia in 1:nptsets){
		ptsc_arglist[[ia]]
		pointmap(ptsc,add=T,pch=cpch[ipch],type=type)
		ipch_ipch+1
	}
	invisible(0)
}	
