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

\name{khvc}
\alias{khvc}
\title{
Covariance matrix for the difference between two K-functions
}
\description{
Calculate the covariance matrix for the difference between two K-functions.
Also return the contribution to the variance for each of the two point
patterns,
}
\usage{
khvc(pts1, pts2, poly, s)
}
\arguments{
\item{pts1}{
An object containing the case locations.
}
\item{pts2}{
An object containing the control locations.
}
\item{poly}{
A polygon enclosing the locations in \code{pts1} and \code{pts2}
}
\item{s}{
A vector of distances at which the calculation is to be made.
}}
\value{
A list with four components:
\(bu \code{$varmat} The upper triangle of the covariance matrix.
\(bu \code{$k11} The variance of Khat for the cases
\(bu \code{$k22} The variance of Khat for the controls
\(bu \code{$k12} The covariance of Khat for the cases and Khat for controls.
}
\section{Note}{
Note that the diagonal of the covariance matrix is
 \code{$k11 - 2 * $k12 + $k22
}
\seealso{
khat, khvmat, secal


}
% Converted by Sd2Rd version 0.3-3.
