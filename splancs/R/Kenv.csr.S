Kenv.csr <- function(nptg,poly,nsim,s,quiet=F)
{
	kmax <- rep(0,length=length(s))
	kmin <- rep(1.0E34,length=length(s))
	
	for(isim in (1:nsim)){
		if(!quiet)cat('Doing simulation ',isim,'\n')
		khsim <- khat(csr(poly,nptg),poly,s)
		kmax <- pmax(kmax,khsim)
		kmin <- pmin(kmin,khsim)
	}
	list(lower=kmin,upper=kmax)
}
