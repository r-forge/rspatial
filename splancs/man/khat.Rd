% Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
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
library(spatial)
ppregion(cardiff$area)
par(mfrow=c(2,2))
plot(seq(2,30,0.5), sqrt(khat(as.points(cardiff), cardiff$poly, seq(2,30,0.5))/pi)-seq(2,30,0.5), type="l", xlab="Splancs - polygon boundary", ylab="Estimated L")
plot(seq(2,30,0.5), sqrt(khat(as.points(cardiff), bbox(as.points(cardiff)), seq(2,30,0.5))/pi)-seq(2,30,0.5), type="l", xlab="Splancs - bounding box boundary", ylab="Estimated L")
plot(Kfn(cardiff, fs=30, k=60)$x[4:60], Kfn(cardiff, fs=30, k=60)$y[4:60] - Kfn(cardiff, fs=30, k=60)$x[4:60], type="l", xlab="spatial - bounding box boundary", ylab="Estimated L")
par(mfrow=c(1,1))
}
\references{
Ripley, B.D. The second-order analysis of stationary point processes,
\emph{ J. Appl. Prob, 13} 255-266
}

\references{
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655, (Barry Rowlingson
<b.rowlingson@lancaster.ac.uk>); the original sources can be accessed at:
http://www.maths.lancs.ac.uk/~rowlings/Splancs/. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
