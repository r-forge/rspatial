\name{thin}
\alias{thin}
\title{
Point Operations
}
\description{
Randomly thin a point data set.\"<description (one liner)>
}
\usage{
thin(pts,n)
}
\arguments{
\item{pts}{
a points data set.
}
\item{n}{
the number of points to return
}}
\value{
Returns a point data set consisting of \code{n} points selected randomly
from the set \code{pts}.
}
\examples{
half <- thin(all,npts(all)/2)      # get half the points in `all'
}
% Converted by Sd2Rd version 0.3-3.
