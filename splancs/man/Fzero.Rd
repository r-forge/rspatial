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

\name{Fzero}
\alias{Fzero}
\title{
Theoretical nearest neighbour distribution function
}
\description{
Calculate the theoretical nearest neighbour distribution function.
}
\usage{
Fzero(density,s)
}
\arguments{
\item{density}{
The density of the point pattern, i.e. the number of points per unit area.
}
\item{s}{
A vector of distances at which to evaluate Fzero
}}
\value{
A vector of the same length as \code{s}, containing the value of Fzero at the 
distances in \code{s}.


}
\section{METHOD}{
Fzero returns the nearest neighbour distribution for a homogeneous planar
Poisson process. In fortran notation, Fzero(s) is
\code{FZERO = 1-EXP(-PI*DENSITY*(S**2))}.
}
\examples{
data(uganda)
plot(Ghat(as.points(uganda), seq(20, 500, 20)), Fzero(pdense(as.points(uganda), uganda$poly), seq(20, 500, 20)), type="l", ylab="Theoretical G", xlab="Estimated G")
lines(c(0,1),c(0,1),lty=2)
}
\seealso{
\code{Fhat},\code{Ghat},\code{pdense}
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
