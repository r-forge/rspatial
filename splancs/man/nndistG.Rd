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

\name{nndistG}
\alias{nndistG}
\title{
Nearest neighbour distances as used by Ghat()
}
\description{
Calculate nearest neighbour distances as used by \code{Ghat()}.
}
\usage{
nndistG(pts)
}
\arguments{
\item{pts}{
A points data set
}}
\value{
Returns a list with components \code{$dists} and \code{$neighs}.
\code{$dists[i]} is the distance
to the nearest neighbour of point \code{i} in \code{pts,} and \code{$neighs[i]}
is the index
of the neighbour of point \code{i}.


}
\examples{
data(uganda)
boxplot(nndistG(as.points(uganda))$dists)
library(stepfun)
plot(ecdf(nndistG(as.points(uganda))$dists))
}
\seealso{
\code{nndistF},\code{Fhat},\code{Ghat},\code{Fzero}
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

