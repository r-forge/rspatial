thin <- function(pts,n)
{
	pts_as.points(pts)
	nptsi_npts(pts)
	if(nptsi<n)
	{
		warning(paste("Requested ",n," points from data with ",nptsi,".\n"))
		n_nptsi
	}
	if(nptsi==0 | n==0)
	{
		pts_NULL
	}
	else
	{
		pts[sample(1:nptsi)[1:n],]
	}
}
