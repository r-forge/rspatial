polymap <- function(poly,add=F,xlab="",ylab="",axes=T,...)
{
	pty.old_par("pty")
	if(pty.old!='s')warning('polymap: plot type not square.')
	if(!add){
		xrnge <- range(poly[, 1],na.rm=T)
		yrnge <- range(poly[, 2],na.rm=T)
		xd_xrnge[2]-xrnge[1]
		yd_yrnge[2]-yrnge[1]
		if(xd > yd) {
			xplot <- xrnge
                        yplot_NULL
                        yplot[1] <- ((yrnge[2] + yrnge[1])/2) - xd/2
                        yplot[2] <- ((yrnge[2] + yrnge[1])/2) + xd/2
               		}
                else {
                        yplot_yrnge
                        xplot_NULL
                        xplot[1] <- ((xrnge[2] + xrnge[1])/2) - yd/2
                        xplot[2] <- ((xrnge[2] + xrnge[1])/2) + yd/2
			}
	par(pty="s")
	plot(poly,xlim=xplot,ylim=yplot,type="n",axes=axes,xlab=xlab,ylab=ylab)
	}

	polygon(poly,density=0,...)
	par("pty"=pty.old)
	invisible(0)
}



