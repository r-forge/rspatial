% Copyright Barry Rowlingson  and 
% Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
% R port: copyright 1998-2000 by Roger S. Bivand
%
%  This program is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation; either version 2 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%

\name{khat}
\alias{khat}
\title{
K-function
}
\description{
Calculates an estimate of the K-function
}
\usage{
khat(pts,poly,s)
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon containing the points
}
\item{s}{
A vector of distances at which to calculate the K function
}}
\value{
A vector like \code{s} containing the value of K at the points in \code{s}.


}
\section{METHOD}{
The K function is defined as the expected number of further points
within a distance s of an arbitrary point, divided by the
overall density of the points. 
In practice an edge-correction is required to avoid biasing the
estimation due to non-recording of points outside the polygon.
}
\examples{
data(cardiff)
UL.khat <- Kenv.csr(length(cardiff$x), cardiff$poly, nsim=99, seq(2,30,2))
plot(seq(2,30,2), sqrt(khat(as.points(cardiff), cardiff$poly, 
seq(2,30,2))/pi)-seq(2,30,2), type="l", xlab="Splancs - polygon boundary", 
ylab="Estimated L", ylim=c(-1,1.5))
lines(seq(2,30,2), sqrt(UL.khat$upper/pi)-seq(2,30,2), lty=2)
lines(seq(2,30,2), sqrt(UL.khat$lower/pi)-seq(2,30,2), lty=2)
}
\references{
Ripley, B.D. 1976 The second-order analysis of stationary point processes,
\emph{ J. Appl. Prob, 13} 255-266;
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655;
the original sources can be accessed at:
\url{http://www.maths.lancs.ac.uk/~rowlings/Splancs/}. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
\keyword{spatial}

