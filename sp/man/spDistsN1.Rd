\name{spDistsN1}
\alias{spDistsN1}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Euclidean or Great Circle distance between points}
\description{
  The function returns a vector of distances between a matrix of 2D points and a single 2D point, using Euclidean or Great Circle distance (WGS84 ellipsoid) methods.
}
\usage{
spDistsN1(pts, pt, longlat = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pts}{A matrix of 2D points}
  \item{pt}{A single 2D point}
  \item{longlat}{if FALSE, Euclidean distance, if TRUE Great Circle distance}
}

\value{
  A numeric vector of distances in the metric of the points if longlat=FALSE, or in kilometers if longlat=TRUE
}

\author{Roger Bivand}


\seealso{\code{\link{is.projected}}}
\examples{
ll <- matrix(c(5, 6, 60, 60), ncol=2)
zapsmall(spDistsN1(ll, ll[1,], longlat=TRUE))
utm32 <- matrix(c(276.9799, 332.7052, 6658.1572, 6655.2055), ncol=2)
spDistsN1(utm32, utm32[1,])
}
\keyword{spatial}
