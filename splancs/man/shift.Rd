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

\name{shift}
\alias{shift}
\title{
Shift a point data set
}
\description{
Shift a point data set
}
\usage{
shift(pts,xsh=0.0,ysh=0.0)
}
\arguments{
\item{pts}{
The point data set to shift
}
\item{xsh}{
Amount to shift along the x-axis
}
\item{ysh}{
Amount to shift along the y-axis
}}
\value{
A point data set like \code{pts}, but with \code{xsh} added to its
x-coordinates, and \code{ysh} added to its y-coordinates.


}
\seealso{
\code{\link{tor.shift}}
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

