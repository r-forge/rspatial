pointmap <- function(pts ,add=F,axes=T,xlab="",ylab="",...)
{
	if(par()$pty!='s')warning('pointmap: plot type not square')

	xrnge <- range(pts[, 1],na.rm=T)
	yrnge <- range(pts[, 2],na.rm=T)


	xd <- xrnge[2] - xrnge[1]
	yd <- yrnge[2] - yrnge[1]
	if(add) 
		{
		points(pts[,1:2,drop=F],...)
		}
	else	
		{
		if(xd > yd) {
			xplot <- xrnge
			yplot <- NULL
			yplot[1] <- ((yrnge[2] + yrnge[1])/2) - xd/2
			yplot[2] <- ((yrnge[2] + yrnge[1])/2) + xd/2
		}
		else {
			yplot <- yrnge
			xplot <- NULL
			xplot[1] <- ((xrnge[2] + xrnge[1])/2) - yd/2
			xplot[2] <- ((xrnge[2] + xrnge[1])/2) + yd/2
		}

		pty.old <- par("pty")
		par(pty="s")
		plot(pts[,1:2,drop=F],xlim=xplot,ylim=yplot,axes=axes,
		xlab=xlab,ylab=ylab,...)
		par(pty=pty.old)

	}

	invisible(0)	

}
