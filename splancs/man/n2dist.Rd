% Copyright Barry Rowlingson  and 
% Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
% R port: copyright 1998-2000 by Roger S. Bivand

\name{n2dist}
\alias{n2dist}
\title{
Nearest neighbours for two point patterns
}
\description{
Calculate nearest neighbours for two point patterns
}
\usage{
n2dist(pts1,pts2)
}
\arguments{
\item{pts1,pts2}{
 Point data sets
}}
\value{
Returns a list with components \code{$dists} and \code{$neighs}.
\code{$dists[i]} is the distance
of the nearest neighbour of point \code{pts1[i,]}  
in \code{pts2} and \code{$neighs[i]}
is the index in \code{pts2} of the point nearest to \code{pts1[i,]}.


}
\seealso{
\code{\link{nndistF}}, \code{\link{Fhat}}, \code{\link{Ghat}}, \code{\link{Fzero}}
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

