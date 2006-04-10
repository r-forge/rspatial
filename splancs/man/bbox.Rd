% Copyright Barry Rowlingson  and 
% Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
% R port: copyright 1998-2000 by Roger S. Bivand

\name{bboxx}
\alias{bboxx}
\title{
Generate a non-closed bounding polygon
}
\description{
Generate a non-closed bounding polygon from the bounding box of an object
}
\usage{
bboxx(obj)
}
\arguments{
\item{obj}{
An object: either a Spatial object or a points data set
}}
\value{
A points data set of four points giving the non-closed coordinates of the bounding box


}
\seealso{
\code{\link{sbox}}
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

