Ghat <- function(pts,s)
{
	Gdists <- nndistG(pts)$dists
	plt(Gdists,s)
}

