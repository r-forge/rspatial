\name{n2dist}
\alias{n2dist}
\title{
Point Summary Statistics
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
\code{nndistF},\code{Fhat},\code{Ghat},\code{Fzero}
}
% Converted by Sd2Rd version 0.3-3.
