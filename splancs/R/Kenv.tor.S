Kenv.tor <- function(pts1,pts2,poly,nsim,s,quiet=F)
{
	rect_bbox(poly)
	kmax <- rep(0, length = length(s))
	kmin <- rep(9.999999999999999e+33, length = length(s))
	for(isim in 1:nsim){
		if(!quiet)cat("Doing shift ", isim, "/", nsim, "\n")
		pts2_rtor.shift(pts2,rect)
		k12sim_k12hat(pts1,pts2,poly,s)
		kmax_pmax(kmax,k12sim)
		kmin_pmin(kmin,k12sim)
	}
	list(lower=kmin,upper=kmax)
}
