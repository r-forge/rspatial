shift <- function(pts,xsh=0.0,ysh=0.0)
{
	pts[,1] <- pts[,1]+xsh
	pts[,2] <- pts[,2]+ysh
	pts
}
