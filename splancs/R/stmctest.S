
stmctest_function(pts,times,poly,tlimits,s,tt,nsim,quiet=F)
{
	stats_NULL
	ntpts_npts(pts)
	
	for(isim in (1:nsim))
	{
		if(!quiet)cat("Doing simulation ", isim, "\n")
		kstsim_stkhat(pts,times,poly,tlimits,s,tt)
		resids_kstsim$kst-outer(kstsim$ks,kstsim$kt)
		stats_c(stats,sum(resids))
		rdat_rank(stats)[1]
		if(!quiet)cat("Data ranks ",rdat," of ",isim,"\n")
		times_sample(times)
	}
	stats
}


# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
