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

\name{dsquare}
\alias{dsquare}
\title{
Distance-squared from a number of points to a number of sources
}
\description{
Computes the distance-squared from a number of points to a number of sources.
}
\usage{
dsquare(pts, srcs, namepref="d")
}
\arguments{
\item{pts}{
A number of points representing the locations of cases and controls.
}
\item{srcs}{
A number of points representing source locations
}
\item{namepref}{
A prefix given to the name of the results.
}}
\value{
A data frame with the same number of  columns as \code{srcs}. The column names will 
be the value of \code{namepref} prefixing the numbers from 1 to the number
of sources.
}
\seealso{
tribble, triblik


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
