# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand

polymap <- function(poly,add=FALSE,xlab="",ylab="",axes=TRUE,...)
{
	if(!add){
		plot(poly,type="n",axes=axes,xlab=xlab,
		ylab=ylab,asp=1)
	}
	polygon(poly,...)
}



