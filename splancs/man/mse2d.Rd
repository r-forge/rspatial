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

\name{mse2d}
\alias{mse2d}
\title{
Mean Square Error for a Kernel Smoothing
}
\description{
Estimate the Mean Square Error for a Kernel Smoothing.
}
\usage{
mse2d(pts,poly,nsmse, range)
}
\arguments{
\item{pts}{
A set of points.
}
\item{poly}{
A polygon containng the points.
}
\item{nsmse}{
Number of steps of \code{h} at which to calculate the mean square error.
}
\item{range}{
Maximum value of \code{h} for calculating the mean square error.
}}
\value{
A list with two components, \code{$h} and \code{$mse}. These vectors store
corresponding values of the mean square error at values of the kernel
smoothing parameter, \code{h}. 
The value of \code{h} corresponding to the minimum value of \code{$mse}
can be passed to \code{kernel2d} as the optimum smoothing parameter.


}
\examples{
data(bodmin)
Mse2d <- mse2d(as.points(bodmin), bodmin$poly, nsmse=50, range=8)
plot(Mse2d$h[5:50],Mse2d$mse[5:50], type="l")
}
\seealso{
\code{kernel2d}


}

\references{
Berman M. \& Diggle P.J. (1989) Estimating Weighted Integrals of the
Second-Order Intensity of a Spatial Point Pattern. 
\emph{ J. R. Statist Soc} B 51 81--92;
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655, (Barry Rowlingson
<b.rowlingson@lancaster.ac.uk>); the original sources can be accessed at:
http://www.maths.lancs.ac.uk/~rowlings/Splancs/. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
\keyword{spatial}

