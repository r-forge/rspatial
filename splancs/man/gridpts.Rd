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


\name{gridpts}
\alias{gridpts}
\title{
Generate a grid of points
}
\description{
Generate a grid of points
}
\usage{
gridpts(poly,npts,xs,ys)
}
\arguments{
\item{poly}{
polygon in which to generate the points
}
\item{npts}{
approximate number of points to generate
}
\item{xs,ys}{
grid spacing in x and y 


Either \code{npts} or \code{xs} and \code{ys} must be specified. If all three
are given then \code{xs} and \code{ys} are ignored. 
}}
\value{
A points object containing a grid of points inside the polygon. If \code{npts}
is specified, then a grid spacing \code{xs} and \code{ys} will be calculated to give
approximately \code{npts} in the polygon. If \code{xs} and \code{ys} are given then these
will be used to generate a number of points in the polygon.


}
% Converted by Sd2Rd version 0.3-3.
