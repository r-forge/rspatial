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

\name{khvmat}
\alias{khvmat}
\title{
Covariance matrix for the difference between two K-functions
}
\description{
Calculate the covariance matrix for the difference between two K-functions 
under random labelling of the corresponding two sets of points.
}
\usage{
khvmat(pts1, pts2, poly, s)
}
\arguments{
\item{pts1}{
An object containing the case locations.
}
\item{pts2}{
An object containing the control locations.
}
\item{poly}{
Polygon enclosing the points in pts1 and pts2.
}
\item{s}{
A vector of distances at which the calculation is to be made.
}}
\value{
A matrix containing the covariances, with the variances on the diagonal.
}
\references{
Diggle P.J and Chetwynd A.C (1991) Second order analysis of
spatial clustering Biometrics 47 1155-63
}
\seealso{
\code{secal}
}
% Converted by Sd2Rd version 0.3-3.


