\name{csr}
\alias{csr}
\title{
Simulations
}
\description{
Generate completely spatially random points on a polygon.
}
\usage{
csr(poly,npoints)
}
\arguments{
\item{poly}{
A polygon data set.
}
\item{npoints}{
The number of points to generate.
}}
\value{
 A point data set consisting of \code{npoints} points distributed randomly,
i.e. as an independent random sample from the uniform distribution
in the polygon defined by \code{poly}.


}
\section{METHOD}{
\code{csr} generates points randomly in the bounding box of \code{poly,} then uses 
\code{pip} to extract those in the polygon. If the number of points remaining is
less than that required, \code{csr} generates some more points in the
bounding box until at least \code{npoints} remain inside the polygon. If too many
points are generated then the list of points is truncated.
}
\section{Side Effects}{
Uses \code{runif()} to generate random numbers and so updates \code{.Random.seed},
the standard S random number generator seed.
}
\examples{
emp.Ghat <- Ghat(as.points(cardiff), seq(0,30,1))
av.Ghat <- numeric(length(emp.Ghat))
U.Ghat <- numeric(length(emp.Ghat))
L.Ghat <- numeric(length(emp.Ghat))
U.Ghat <- -99999
L.Ghat <- 99999
for(i in 1:99) {
S.Ghat <- Ghat(csr(cardiff$poly, length(cardiff$x)), seq(0,30,1))
av.Ghat <- av.Ghat + S.Ghat
L.Ghat <- pmin(S.Ghat, L.Ghat)
U.Ghat <- pmax(S.Ghat, U.Ghat)
}
av.Ghat <- av.Ghat/99
plot(av.Ghat, emp.Ghat, type="l", xlim=c(0,1), ylim=c(0,1), xlab="Simulated average G", ylab="Empirical G")
lines(c(0,1),c(0,1),lty=2)
lines(U.Ghat,emp.Ghat,lty=3)
lines(L.Ghat,emp.Ghat,lty=3)
}
% Converted by Sd2Rd version 0.3-3.
