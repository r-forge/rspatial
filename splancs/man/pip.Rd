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

\name{pip}
\alias{pip}
\title{
Points inside or outside a polygon
}
\description{
Return points inside or outside a polygon.
}
\usage{
pip(pts,poly,out=F)
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon data set
}
\item{out}{
If \code{out=T}, return the points outside the polygon, else the points inside.
}}
\value{
\code{pip} returns the points of \code{pts} that lie inside (or outside with
\code{out=T})
the polygon \code{poly}. Compare this with \code{inpip}, which returns
the indices of
the points in the polygon, and \code{inout} which returns a logical vector
indicating whether points are inside or outside.


}
\section{METHOD}{
\code{pip} calls \code{inout}, then selects the appropriate sub-set of points.
}
\seealso{
\code{inpip},\code{inout}
}
% Converted by Sd2Rd version 0.3-3.
