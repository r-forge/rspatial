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

\name{stsecal}
\alias{stsecal}
\title{
Standard error for space-time clustering
}
\description{
Computes the standard error for space-time clustering.
}
\usage{
stsecal(pts, times, poly, tlim, s, tm)
}
\arguments{
\item{pts}{
A set of points, as defined in Splancs.
}
\item{times}{
A vector of times, the same length as the number of points in \code{pts}
}
\item{poly}{
A polygon enclosing the points
}
\item{tlim}{
A vector of length 2 specifying the upper and lower temporal domain.
}
\item{s}{
A vector of spatial distances for the analysis
}
\item{tm}{
A vector of times for the analysis
}}
\value{
A matrix of dimension \code{[length(s),length(t)]} is returned. Element 
\code{[i,j]} is the standard error at \code{s[i],t[j]}.
See Diggle Chetwynd Haggkvist and Morris (1993)for details.
}
\seealso{
\code{\link{stkhat}}, \code{\link{stsecal}}, \code{\link{stvmat}}, \code{\link{stdiagn}}
}

\references{
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655;
the original sources can be accessed at:
\url{http://www.maths.lancs.ac.uk/~rowlings/Splancs/}. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
\keyword{spatial}

