\name{Kenv.csr}
\alias{Kenv.csr}
\title{
Envelope of Khat from simulations of complete spatial randomness
}
\description{
Compute envelope of Khat from simulations of complete spatial randomness.
}
\usage{
Kenv.csr(nptg,poly,nsim,s,quiet=F)
}
\arguments{
\item{nptg}{
Number of points to generate in each simulation.
}
\item{poly}{
Polygon in which to generate the points.
}
\item{nsim}{
Number of simulations to do.
}
\item{s}{
Vector of distances at which to calculate the envelope.
}
\item{quiet}{
If false, print a message after every simulation for progress monitoring. If
true, print no messages.
}}
\value{
A list with two components, called \code{$upper} and \code{$lower}. Each
component is a vector like \code{s}. The two components contain the upper 
and lower bound of the Khat envelope. 


}
\examples{
data(cardiff)
library(spatial)
ppregion(cardiff$area)
par(mfrow=c(2,2))
env.car <- Kenvl(fs=30, nsim=99, Psim(length(cardiff$x)))
plot(Kfn(cardiff, fs=30, k=15)$x, Kfn(cardiff, fs=30, k=15)$y - Kfn(cardiff, fs=30, k=15)$x, type="l", xlab="spatial - bounding box boundary", ylab="Estimated L", ylim=c(-1.2,2.7))
lines(env.car$x, env.car$lower-env.car$x, lty=2)
lines(env.car$x, env.car$upper-env.car$x, lty=2)
ULbb.khat <- Kenv.csr(length(cardiff$x), bbox(as.points(cardiff)), nsim=99, seq(2,30,2))
plot(seq(2,30,2), sqrt(khat(as.points(cardiff), bbox(as.points(cardiff)), seq(2,30,2))/pi)-seq(2,30,2), type="l", xlab="Splancs - bounding box boundary", ylab="Estimated L", ylim=c(-1.2,2.7))
lines(seq(2,30,2), sqrt(ULbb.khat$upper/pi)-seq(2,30,2), lty=2)
lines(seq(2,30,2), sqrt(ULbb.khat$lower/pi)-seq(2,30,2), lty=2)
UL.khat <- Kenv.csr(length(cardiff$x), cardiff$poly, nsim=99, seq(2,30,2))
plot(seq(2,30,2), sqrt(khat(as.points(cardiff), cardiff$poly, seq(2,30,2))/pi)-seq(2,30,2), type="l", xlab="Splancs - polygon boundary", ylab="Estimated L", ylim=c(-1,1.5))
lines(seq(2,30,2), sqrt(UL.khat$upper/pi)-seq(2,30,2), lty=2)
lines(seq(2,30,2), sqrt(UL.khat$lower/pi)-seq(2,30,2), lty=2)
par(mfrow=c(1,1))
}
\seealso{
\code{csr},\code{khat}
}
% Converted by Sd2Rd version 0.3-3.
