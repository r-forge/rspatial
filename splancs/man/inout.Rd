% Copyright Barry Rowlingson  and 
% Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
% R port: copyright 1998-2001 by Roger S. Bivand
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

\name{inout}
\alias{inout}
\title{
Test points for inclusion in a polygon
}
\description{
Test points for inclusion in a polygon.
}
\usage{
inout(pts,poly,bound=NULL)
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon data set
}
\item{bound}{If points fall exactly on polygon vertices, the default NULL gives arbitrary assignments. If TRUE, then all points identical in machine numerical representation terms are set as within the polygon, if FALSE, outside.}
}
\value{
A vector of logical values. \code{True} means the point was inside the
polygon, \code{False} means the point was outside. Note that "inside" is an arbitrary concept for points precisely on the polygon boundary.



}
\seealso{
\code{\link{inpip}},\code{\link{pip}}
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

