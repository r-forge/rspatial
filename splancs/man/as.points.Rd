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

\name{as.points}
\alias{as.points}
\title{
Creates data in spatial point format
}
\description{
Creates data in spatial point format.
}
\usage{
as.points(p)
}
\arguments{
\item{p}{
any object(s), such as x and y vectors of the same length, or a list or data
frame containing x and y vectors. Valid options for \code{p} are:
\itemize{
\item{a points object ; returns it unaltered.}
\item{a list with x and y elements of the same length ; returns a
points object with the x and y elements as the coordinates of the points.}
\item{two vectors of equal length ; returns a points object with the 
first vector as the x coordinates, the second vector as the y-coordinates.}
}
}
}
\value{
\code{as.points} tries to return \code{p} as a points object. }

\references{
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655, (Barry Rowlingson
<b.rowlingson@lancaster.ac.uk>); the original sources can be accessed at:
http://www.maths.lancs.ac.uk/~rowlings/Splancs/. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}
% Converted by Sd2Rd version 0.3-3.
