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

\name{rtor.shift}
\alias{rtor.shift}
\title{
Random toroidal shift on a point data set
}
\description{
Perform a random toroidal shift on a point data set
}
\usage{
rtor.shift(pts,rect)
}
\arguments{
\item{pts}{
The point data set to shift
}
\item{rect}{
A rectangle defining the region for the toroidal map. If not given, 
the bounding box of \code{pts} is used.
}}
\value{
A point data set like \code{pts}, but after application of a random toroidal 
shift along the x and y axes. 
}
\section{METHOD}{
The planar region defined by \code{rect}
is assumed connected at its top and bottom edges, and at its left and
right sides. A random shift is applied to the 
points and the resulting set of points returned. 


}
\seealso{
\code{tor.shift}
}
% Converted by Sd2Rd version 0.3-3.
