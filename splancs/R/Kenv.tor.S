# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand

Kenv.tor <- function(pts1,pts2,poly,nsim,s,quiet=FALSE)
{
	rect <- bbox(poly)
	kmax <- rep(0, length = length(s))
	kmin <- rep(9.999999999999999e+33, length = length(s))
	for(isim in 1:nsim){
		if(!quiet)cat("Doing shift ", isim, "/", nsim, "\n")
		pts2 <- rtor.shift(pts2,rect)
		k12sim <- k12hat(pts1,pts2,poly,s)
		kmax <- pmax(kmax,k12sim)
		kmin <- pmin(kmin,k12sim)
	}
	list(lower=kmin,upper=kmax)
}
