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

\name{inpip}
\alias{inpip}
\title{
Select points inside a polygon
}
\description{
Select points inside a polygon
}
\usage{
inpip(pts,poly)
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon data set
}}
\value{
\code{inpip} returns a vector of indices of the points in \code{pts} that are located
in the polygon.


}
\seealso{
\code{pip}
}
% Converted by Sd2Rd version 0.3-3.
