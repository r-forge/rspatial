# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2002 by Roger S. Bivand

khat <- function(pts, poly, s, newstyle=FALSE)
{
	ptsx <- pts[,1]
	ptsy <- pts[,2]
	npt <- npts(pts)

	ns <- length(s)
	s <- sort(s)

	np <- length(poly[,1])
	polyx <- c(poly[,1],poly[1,1])
	polyy <- c(poly[,2],poly[1,2])

	hkhat <- rep(0,times=ns)
	counts <- matrix(0, nrow=npt, ncol=ns)
	mode(counts) <- "integer"
	hkhats <- matrix(0, nrow=npt, ncol=ns)

	klist <- .Fortran("trykh",
		as.double(ptsx),
		as.double(ptsy),
		as.integer(npt),
		as.double(polyx),
		as.double(polyy),
		as.integer(np),
		as.double(s),
		as.integer(ns),
		as.double(hkhat),
		as.integer(counts),
		as.double(hkhats),
		as.integer(npt*ns))
	if (newstyle) {
		res <- list(khat=as.numeric(klist[[9]]),
			counts=matrix(klist[[10]], nrow=npt, ncol=ns),
			khats=matrix(klist[[11]], nrow=npt, ncol=ns),
			s=s)
			class(res) <- "khat"
	} else {
		res <- as.numeric(klist[[9]])
	}
	res
}

print.khat <- function(x, ...) {
	print(x$khat, ...)
	invisible(x)
}

plot.khat <- function(x, ...) {
	plot(x=x$s, y=x$khat, type="l", ylab="khat", xlab="distance", ...)
	invisible(x)
}


