\name{Kenv.label}
\alias{Kenv.label}
\title{
Envelope of K1hat-K2hat from random labelling of two point patterns
}
\description{
Compute envelope of K1hat-K2hat from random labelling of two point patterns
}
\usage{
Kenv.label(pts1,pts2,poly,nsim,s,quiet=F)
}
\arguments{
\item{pts1}{
First point data set.
}
\item{pts2}{
Second point data set.
}
\item{poly}{
Polygon containing the points.
}
\item{nsim}{
Number of random labellings to do.
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
component is a vector like \code{s}.
}
\section{METHOD}{
The two point data sets are randomly labelled using \code{rlabel}, then
\code{Khat} is called to estimate the K-function for each resulting set
at the distances in \code{s}. The difference between these two estimates
is then calculated. 
The maximum and minimum values of this difference at each distance,over
the \code{nlab}
labellings is returned.


}
\examples{
data(okwhite)
data(okblack)
okpoly <- list(x=c(okwhite$x, okblack$x), y=c(okwhite$y, okblack$y))
K1.hat <- khat(as.points(okwhite), bbox(as.points(okpoly)), seq(5,80,5))
K2.hat <- khat(as.points(okblack), bbox(as.points(okpoly)), seq(5,80,5))
K.diff <- K1.hat-K2.hat
plot(seq(5,80,5), K.diff, xlab="distance", ylab=expression(hat(K)[1]-hat(K)[2]), ylim=c(-11000,7000), type="l", main="Simulation envelopes, random labelling")
env.lab <- Kenv.label(as.points(okwhite), as.points(okblack), bbox(as.points(okpoly)), nsim=99, s=seq(5,80,5))
lines(seq(5,80,5), env.lab$upper, lty=2)
lines(seq(5,80,5), env.lab$lower, lty=2)
}
\seealso{
\code{rlabel},\code{khat}
}
% Converted by Sd2Rd version 0.3-3.
