\name{Kenv.tor}
\alias{Kenv.tor}
\title{
Envelope of K12hat from random toroidal shifts of two point patterns
}
\description{
Compute envelope of K12hat from random toroidal shifts of two point patterns.
}
\usage{
Kenv.tor(pts1,pts2,poly,nsim,s,quiet=F)
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
Number of random toroidal shifts to do.
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
The second point data set is randomly shifted using \code{rtor.shift}
in the rectangle defined by \code{poly}. Then \code{k12hat} is called 
to compute K12hat for the two patterns. 
The upper and lower values of K12hat over the \code{ntor}
toroidal shifts are returned.


}
\examples{
data(okwhite)
data(okblack)
okpoly <- list(x=c(okwhite$x, okblack$x), y=c(okwhite$y, okblack$y))
plot(seq(5,80,5), sqrt(k12hat(as.points(okwhite), as.points(okblack), bbox(as.points(okpoly)), seq(5,80,5))/pi) - seq(5,80,5), xlab="distance", ylab=expression(hat(L)[12]), ylim=c(-35,35), type="l",main="Simulation envelopes, random toroidal shifts")
env.ok <- Kenv.tor(as.points(okwhite), as.points(okblack), bbox(as.points(okpoly)), nsim=99, s=seq(5,80,5))
lines(seq(5,80,5), sqrt(env.ok$upper/pi)-seq(5,80,5), lty=2)
lines(seq(5,80,5), sqrt(env.ok$lower/pi)-seq(5,80,5), lty=2)
}
\seealso{
\code{rtor.shift},\code{k12hat}
}
% Converted by Sd2Rd version 0.3-3.
