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

\name{kernel2d}
\alias{kernel2d}
\title{
Kernel smoothing of a point pattern
}
\description{
Perform kernel smoothing of a point pattern
}
\usage{
kernel2d(pts,poly,h0,nx=20,ny=20,kernel='quartic')
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon data set
}
\item{h0}{
The kernel width parameter
}
\item{nx}{
Number of points along the x-axis of the returned grid.
}
\item{ny}{
Number of points along the y-axis of the returned grid.
}
\item{kernel}{
Type of kernel function to use. Currently only the quartic kernel is implemented.
}}
\value{
A list with the following components:
\item \code{$x} List of x-coordinates at which the kernel function has been evaluated.
\item \code{$y} List of y-coordinates at which the kernel function has been evaluated.
\item \code{$z} A matrix of dimension \code{nx} by \code{ny} containing the value of
the kernel function.
\item \code{$h0},\code{$kernel}, containing the values input to \code{kernel2d}




}
\section{METHOD}{
The kernel estimate, with a correction for edge effects, is computed for
a grid of points that span the
input polygon. The kernel function for points in the grid that are outside the polygon are returned
as NA's.
The output list is in a format that can be read into \code{image()} directly,
for display and superposition onto other plots.
}

\examples{
data(bodmin)
require(MASS)
eqscplot(bodmin$poly, type="n")
image(kernel2d(as.points(bodmin), bodmin$poly, h0=2, nx=100, ny=100), add=T, col=terrain.colors(20))
pointmap(as.points(bodmin), add=T)
polymap(bodmin$poly, add=T)
}

\references{
Berman M. and Diggle P.J. (1989) Estimating Weighted Integrals of the
Second-Order Intensity of Spatial Point Patterns.  \emph{J. R. Statist
Soc} B51 81-92; Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point
pattern analysis code in S-Plus.  Computers and Geosciences, 19, 627-655,
(Barry Rowlingson <b.rowlingson@lancaster.ac.uk>); the original sources
can be accessed at: http://www.maths.lancs.ac.uk/~rowlings/Splancs/. See
also Bivand, R. and Gebhardt, A. 2000 Implementing functions for spatial
statistical analysis using the R language. Journal of Geographical
Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
