Kenv.csr <- function(nptg,poly,nsim,s,quiet=F)
{
	kmax_rep(0,length=length(s))
	kmin_rep(1.0E34,length=length(s))
	
	for(isim in (1:nsim)){
		if(!quiet)cat('Doing simulation ',isim,'\n')
		khsim_khat(csr(poly,nptg),poly,s)
		kmax_pmax(kmax,khsim)
		kmin_pmin(kmin,khsim)
	}
	list(lower=kmin,upper=kmax)
}
