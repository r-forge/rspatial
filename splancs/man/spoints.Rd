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

\name{spoints}
\alias{spoints}
\title{
Point Objects
}
\description{
Creates and tests for data in spatial point format.
}
\usage{
spoints(data,npoints=length(data)/2)
}
\arguments{
\item{data}{
vector containing the data values for the points
in order (x1,y1),(x2,y2),\dots{}


}
\item{npoints}{
number of points to generate.
}}
\value{
\code{spoints} returns an object suitable for use as a point data
object. If \code{npoints} is given, the vector data is either truncated
or repeated until sufficient data values are generated.
The returned object is a two-column matrix, where the first column stores the 
x-coordinate, and the second column stores the y-coordinate.


}
\seealso{
\code{npts}
}
% Converted by Sd2Rd version 0.3-3.
