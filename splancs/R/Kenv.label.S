Kenv.label <- function(pts1,pts2,poly,nsim,s,quiet=F)
{
	kmax_rep(0,length=length(s))
	kmin_rep(1.0E34,length=length(s))
	
	for(isim in (1:nsim)){
		if(!quiet)cat('Doing labelling ',isim,'/',nsim,'\n')
		labpts_rlabel(pts1,pts2)
		k1sim_khat(labpts[[1]],poly,s)
		k2sim_khat(labpts[[2]],poly,s)
		diffk_k1sim-k2sim
		kmax_pmax(kmax,diffk)
		kmin_pmin(kmin,diffk)
	}
	list(lower=kmin,upper=kmax)
}

