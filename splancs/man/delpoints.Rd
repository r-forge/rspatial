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

\name{delpoints}
\alias{delpoints}
\title{
Select points to delete from a points data set
}
\description{
Select points to delete from a points data set.
}
\usage{
delpoints(pts,add=F,\dots)
}
\arguments{
\item{pts}{
a points data set
}
\item{add}{
if false, plot the points using \code{pointmap}.
}}
\section{METHOD}{
Using the mouse, the user selects points on the current graphics device.
These points are marked on the plot as they are selected. The function
returns the remaining points as a points object.
}
\value{
A points object containing the undeleted points.


}
\section{Side Effects}{
If \code{add} is false the points are plotted on the current plot device.
}

\references{
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655, (Barry Rowlingson
<b.rowlingson@lancaster.ac.uk>); the original sources can be accessed at:
http://www.maths.lancs.ac.uk/~rowlings/Splancs/. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
\keyword{spatial}

