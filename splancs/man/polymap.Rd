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

\name{polymap}
\alias{polymap}
\title{
Graphics
}
\description{
Plots point and polygon data sets on the current graphics device.
}
\usage{
polymap(poly,add=F,xlab="",ylab="",axes=T,...)
}
\arguments{
\item{pts}{
a points data set.
}
\item{add}{
if false, start a new plot. If true, superimpose on current plot.
}
\item{xlab,ylab}{
Label strings for x and y axes.
}
\item{axes}{
if true, display axes with labelling. If false, do not display any 
axes on the plot.
}
\item{...}{
Graphical arguments may be entered, and these are passed to the
standard S \code{points} and \code{polygon} routines.


}}
\section{Side Effects}{
The specified data set is plotted on the current graphics device, either
as points or polygons. For \code{polymap}, the last point in the data set
is drawn connected to the first point.
}
\section{NOTES}{
\code{pointmap} and \code{polymap} preserve
the aspect ratio in the data by using the \code{asp=1} plot argument.
Graphical parameters can also be supplied to these routines, and are passed 
through to \code{plot}. Some useful parameters include \code{pch} to change the plotting
character for points, \code{lty} to change the line type for polygons, and 
\code{type="n"} to just set up axes for the plot without plotting anything.
}
\seealso{
\code{\link{par}}, \code{\link{mpoint}}
}
\examples{
data(bodmin)
plot(bodmin$poly, asp=1, type="n")
pointmap(as.points(bodmin), add=T)
polymap(bodmin$poly, add=T)
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

