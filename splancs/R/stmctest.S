# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand


stmctest <- function(pts,times,poly,tlimits,s,tt,nsim,quiet=FALSE)
{
	stats <- NULL
	ntpts <- npts(pts)
	
	for(isim in (1:nsim))
	{
		if(!quiet)cat("Doing simulation ", isim, "\n")
		kstsim <- stkhat(pts,times,poly,tlimits,s,tt)
		resids <- kstsim$kst-outer(kstsim$ks,kstsim$kt)
		stats <- c(stats,sum(resids))
		rdat <- rank(stats)[1]
		if(!quiet)cat("Data ranks ",rdat," of ",isim,"\n")
		times <- sample(times)
	}
	stats
}


# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
