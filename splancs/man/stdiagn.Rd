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

\name{stdiagn}
\alias{stdiagn}
\title{
Summary plots for clustering analysis
}
\description{
Produces some summary plots for clustering analysis
}
\usage{
stdiagn(pts, stkh, stse, stmc=0)
}
\arguments{
\item{pts}{
A set of points, as used in Splancs
}
\item{stkh}{
An object returned from \code{stkhat}
}
\item{stse}{
An object returned from \code{stsecal}
}
\item{stmc}{
An object returned from \code{stmctest}
}}
\details{
Four plots are produced on the current graphics device.
The first plot is simply a map of the data. The second is a perspective plot
of the difference between space-time K-function and the product of spatial
and temporal K-functions. The third plot is of the 
standardised residuals against the product of spatial and temporal
K-functions. If the Monte-Carlo data is given the fourth plot is a
a histogram of the test statistics, with the value for the data indicated
with a vertical line.
See Diggle, Chetwynd, Haggkvist, and Morris (1993) for details.
}
\seealso{
\code{\link{stkhat}}, \code{\link{stsecal}}, \code{\link{stvmat}}, \code{\link{stmctest}}
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

