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

\name{stkhat}
\alias{stkhat}
\title{
Space-time K-functions
}
\description{
Compute the space-time K-functions
}
\usage{
stkhat(pts, times, poly, tlimits, s, tm)
}
\arguments{
\item{pts}{
A set of points as defined in Splancs
}
\item{times}{
A vector of times, the same length as the number of points in \code{pts}
}
\item{poly}{
A polygon enclosing the points
}
\item{tlimits}{
A vector of length 2 specifying the upper and lower temporal domain.
}
\item{s}{
A vector of spatial distances for the analysis.
}
\item{tm}{
A vector of times for the analysis
}}
\value{
A list with the following components is returned:
\item{s, t}{The spatial and temporal scales}
\item{ks}{The spatial K-function}
\item{kt}}{The temporal K-function}
\item{kst}{The space-time K-function}
For details see Diggle, Chetwynd, Haggkvist, and Morris (1993)
}
\seealso{
stsecal, stvmat, stmctest, stdiagn


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

