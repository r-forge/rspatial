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

\name{Fhat}
\alias{Fhat}
\title{
F nearest neighbour distribution function
}
\description{
Calculates an estimate of the F nearest neighbour distribution function
}
\usage{
Fhat(pts1,pts2,s)
}
\arguments{
\item{pts1}{
A points data set
}
\item{pts2}{
A points data set
}
\item{s}{
A vector of distances at which to evaluate Fhat
}}
\value{
A vector of the same length as \code{s}, containing the value of Fhat at the 
distances in \code{s}.


}
\section{METHOD}{
The function \code{Fhat(pts1,pts2,s)} is defined as the proportion of members of a
point set \code{pts2} for which the distance to the nearest member of
another points set \code{pts1} is less than or equal to \code{s}.
}
\examples{
data(uganda)
plot(seq(20, 500, 20), Fhat(as.points(uganda), as.points(csr(uganda$poly, length(uganda$x))), seq(20, 500, 20)), type="l", xlab="distance", ylab="Estimated F")
plot(Ghat(as.points(uganda), seq(20, 500, 20)), Fhat(as.points(uganda), as.points(csr(uganda$poly, length(uganda$x))), seq(20, 500, 20)), type="l", xlab="Estimated G", ylab="Estimated F")
lines(c(0,1),c(0,1),lty=2)
}
\seealso{
\code{nndistF},\code{Fzero}
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
