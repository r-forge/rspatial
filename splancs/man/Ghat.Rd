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

\name{Ghat}
\alias{Ghat}
\title{
G nearest neighbour distribution function
}
\description{
Calculates an estimate of the G nearest neighbour distribution function.
}
\usage{
Ghat(points,s)
}
\arguments{
\item{points}{
A points data set
}
\item{s}{
A vector of distances at which to evaluate the G function
}}
\value{
A vector of the same length as \code{s}, containing the estimate of G at the 
distances in \code{s}.


}
\section{METHOD}{
The function \code{Ghat(points,s)} is defined as the proportion of members of a
point set for which the distance to the nearest other member of the set
is less than or equal to \code{s}.
}
\examples{
data(uganda)
plot(seq(20, 500, 20), Ghat(as.points(uganda), seq(20, 500, 20)), type="l", xlab="distance", ylab="Estimated G")
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
\keyword{spatial}

