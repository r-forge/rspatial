zoom <- function(quiet=F,out=F,...)
{
	if(!out){
		if(!quiet){
			cat("Enter 2 points as corners of zoom area\n")
		}
		pointmap(bbox(as.points(locator(2,type="l"))),type="n",...)
	}
	if(out){
		usr_par()$usr
		xwidth_usr[2]-usr[1]
		ywidth_usr[4]-usr[3]
		xmin_usr[1]-xwidth
		xmax_usr[2]+xwidth
		ymin_usr[3]-ywidth
		ymax_usr[4]+ywidth
		pointmap(cbind(c(xmin,xmax),c(ymin,ymax)),type='n')
	}
	invisible(0)
}

