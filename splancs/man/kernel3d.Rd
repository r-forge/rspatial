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

\name{kernel3d}
\alias{kernel3d}
\title{
Space-time kernel
}
\description{
Compute the space-time kernel
}
\usage{
kernel3d(pts, times, xgr, ygr, tgr, hxy, ht)
}
\arguments{
\item{pts}{
A matrix of event coodinates x,y.
}
\item{times}{
A vector of event times, t.
}
\item{xgr}{
The values of x at which to compute the kernel function.
}
\item{ygr}{
The values of y at which to compute the kernel function.
}
\item{tgr}{
The values of t at which to compute the kernel function.
}
\item{hxy}{
The quartic kernel width in the x and y direction.
}
\item{ht}{
The quartic kernel width in the temporal direction.
}}
\value{
A list is returned. Most of the components are just copies of the 
input parameters, except for the \code{$v} parameter.
This is a three dimensional array containing the kernel-smoothed
values. Its dimension is
\code{[length(xgr),length(ygr),length(tgr)]}. 
}
\seealso{
kerview
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

