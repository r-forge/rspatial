Kenv.label <- function(pts1,pts2,poly,nsim,s,quiet=F)
{
	kmax <- rep(0,length=length(s))
	kmin <- rep(1.0E34,length=length(s))
	
	for(isim in (1:nsim)){
		if(!quiet)cat('Doing labelling ',isim,'/',nsim,'\n')
		labpts <- rlabel(pts1,pts2)
		k1sim <- khat(labpts[[1]],poly,s)
		k2sim <- khat(labpts[[2]],poly,s)
		diffk <- k1sim-k2sim
		kmax <- pmax(kmax,diffk)
		kmin <- pmin(kmin,diffk)
	}
	list(lower=kmin,upper=kmax)
}

