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

\name{stvmat}
\alias{stvmat}
\title{
Variance matrix for space-time clustering
}
\description{
Compute the variance matrix for space-time clustering
}
\usage{
stvmat(pts, times, poly, tlim, s, tm)
}
\arguments{
\item{pts}{
A set of points.
}
\item{times}{
A vector of times, the same length as the number of points in \code{pts}
}
\item{poly}{
A polygon that encloses the points
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
A four-dimensional matrix is returned. The covariance between space-time
\code{t1,s1} and \code{t2,s2} is given by the corresponding element \code{[t1,s1,t2,s2]}
For full details, see Diggle, Chetwynd, Haggkvist and Morris (1993)
}
\seealso{
stkhat, stsecal, stmctest, stdiagn
}
% Converted by Sd2Rd version 0.3-3.
