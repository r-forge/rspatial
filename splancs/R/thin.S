thin <- function(pts,n)
{
	pts <- as.points(pts)
	nptsi <- npts(pts)
	if(nptsi<n)
	{
		warning(paste("Requested ",n," points from data with ",nptsi,".\n"))
		n <- nptsi
	}
	if(nptsi==0 | n==0)
	{
		pts <- NULL
	}
	else
	{
		pts[sample(1:nptsi)[1:n],]
	}
}
