zoom <- function(quiet=F,out=F,...)
{
	if(!out){
		if(!quiet){
			cat("Enter 2 points as corners of zoom area\n")
		}
		pointmap(bbox(as.points(locator(2,type="l"))),type="n",...)
	}
	if(out){
		usr <- par()$usr
		xwidth <- usr[2]-usr[1]
		ywidth <- usr[4]-usr[3]
		xmin <- usr[1]-xwidth
		xmax <- usr[2]+xwidth
		ymin <- usr[3]-ywidth
		ymax <- usr[4]+ywidth
		pointmap(cbind(c(xmin,xmax),c(ymin,ymax)),type='n')
	}
	invisible(0)
}

