\name{nndistG}
\alias{nndistG}
\title{
Nearest neighbour distances as used by Ghat()
}
\description{
Calculate nearest neighbour distances as used by \code{Ghat()}.
}
\usage{
nndistG(pts)
}
\arguments{
\item{pts}{
A points data set
}}
\value{
Returns a list with components \code{$dists} and \code{$neighs}.
\code{$dists[i]} is the distance
to the nearest neighbour of point \code{i} in \code{pts,} and \code{$neighs[i]}
is the index
of the neighbour of point \code{i}.


}
\examples{
data(uganda)
boxplot(nndistG(as.points(uganda))$dists)
library(stepfun)
plot(ecdf(nndistG(as.points(uganda))$dists))
}
\seealso{
\code{nndistF},\code{Fhat},\code{Ghat},\code{Fzero}
}
% Converted by Sd2Rd version 0.3-3.
