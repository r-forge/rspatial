addpoints <- function(pts,plot=F,quiet=F)
{
	if(!plot & !missing(pts)){
		pointmap(pts)
	}

	if(missing(pts))pts <- NULL

	if(!quiet)cat("Use button 1 to enter new points - button 2 when finished.\n")
	newpts <- locator(type="p")
	pts <- rbind(pts,cbind(newpts$x,newpts$y))
	pts
}
