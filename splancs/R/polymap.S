polymap <- function(poly,add=F,xlab="",ylab="",axes=T,...)
{
#	pty.old <- par("pty")
#	if(pty.old!='s')warning('polymap: plot type not square.')
	if(!add){
		xrnge <- range(poly[, 1],na.rm=T)
		yrnge <- range(poly[, 2],na.rm=T)
		xd <- xrnge[2]-xrnge[1]
		yd <- yrnge[2]-yrnge[1]
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
#	par(pty="s")
	plot(poly,xlim=xplot,ylim=yplot,type="n",axes=axes,xlab=xlab,ylab=ylab)
	}

#	polygon(poly,density=0,...)
	polygon(poly,...)
#	par("pty"=pty.old)
	invisible(0)
}



