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

\name{zoom}
\alias{zoom}
\title{
Interactively specify a region of a plot for expansion
}
\description{
Interactively specify a region of a plot for expansion
}
\usage{
zoom(out=F,quiet=F,\dots)
}
\arguments{
\item{out}{
If true, expand the limits of the current plot by a factor of three, centred
on the current plot.
}
\item{quiet}{
If false, prompt the user to enter two coordinates. If true, say nothing.
}
\item{...}{
Other arguments are passed through to pointmap.
}}
\value{
None


}
\section{Side Effects}{
A prompt is optionally displayed, and the user selects two points
forming the diagonal of a rectangle. A new, empty plot is created that has its
axis limits set to the bounding square of the selected rectangle. 
If \code{out=T}, no prompt is displayed, and a new blank plot is created with
its limits in x and y set to span an area three times the height and width
centred on the current centre.
}
\seealso{
pointmap
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
