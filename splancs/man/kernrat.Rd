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

\name{kernrat}
\alias{kernrat}
\title{
Ratio of two kernel smoothings
}
\description{
Return the ratio of two kernel smoothings
}
\usage{
kernrat(pts1,pts2,poly,h1,h2,nx=20,ny=20,kernel='quartic')
}
\arguments{
\item{pts1,pts2}{
Point data sets
}
\item{poly}{
A polygon data set
}
\item{h1,h2}{
The kernel width parameters, \code{h1} for \code{pts1}, and \code{h2} for \code{pts2}
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
\item \code{$z} A matrix of dimension \code{nx} by \code{ny} containing the ratio of the kernel functions.
\item \code{$h} A vector of length 2 containing \code{h1} and \code{h2}
\item \code{$kernel} a character string containing the kernel name.


}
\seealso{
kernel2d, mse2d
}
\references{
Berman M. and Diggle P.J. (1989) Estimating Weighted Integrals of the
Second-Order Intensity of Spatial Point Patterns.
\emph{J. R. Statist Soc} B51 81-92;
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655, (Barry Rowlingson
<b.rowlingson@lancaster.ac.uk>); the original sources can be accessed at:
http://www.maths.lancs.ac.uk/~rowlings/Splancs/. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
