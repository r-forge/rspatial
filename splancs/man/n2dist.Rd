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

\name{n2dist}
\alias{n2dist}
\title{
Nearest neighbours for two point patterns
}
\description{
Calculate nearest neighbours for two point patterns
}
\usage{
n2dist(pts1,pts2)
}
\arguments{
\item{pts1,pts2}{
 Point data sets
}}
\value{
Returns a list with components \code{$dists} and \code{$neighs}.
\code{$dists[i]} is the distance
of the nearest neighbour of point \code{pts1[i,]}  
in \code{pts2} and \code{$neighs[i]}
is the index in \code{pts2} of the point nearest to \code{pts1[i,]}.


}
\seealso{
\code{nndistF},\code{Fhat},\code{Ghat},\code{Fzero}
}
% Converted by Sd2Rd version 0.3-3.
