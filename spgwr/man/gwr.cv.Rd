\name{gwr.sel}
\alias{gwr.sel}
\alias{gwr.cv.f}
\alias{gwr.cv.adapt.f}
\alias{gwr.aic.f}
\alias{gwr.aic.adapt.f}
\title{Crossvalidation of bandwidth for geographically weighted regression}
\description{
The function finds a bandwidth for a given geographically weighted regression
by optimzing function \code{gwr.cv.f}. This scores the root mean square
prediction error for the geographically weighted regressions, choosing the
bandwidth minimizing this quantity. This replicates the crossvalidation
function in the original Fortran code.
}
\usage{
gwr.sel(formula, data=list(), coords, adapt=FALSE, gweight=gwr.gauss, method = "cv", verbose = TRUE)
}
\arguments{
  \item{formula}{regression model formula as in \code{lm}}
  \item{data}{model data frame as in \code{lm}}
  \item{coords}{matrix of coordinates of points representing the spatial
  positions of the observations}
  \item{adapt}{either TRUE: find the proportion between 0 and 1 of observations to include in weighting scheme (k-nearest neighbours), or FALSE --- find global bandwidth}
  \item{gweight}{geographical weighting function, at present only
  \code{gwr.gauss()} or \code{gwr.bisquare()}}
  \item{method}{}
  \item{verbose}{}
}
\value{
returms the cross-validation bandwidth.
}
\seealso{\code{\link{gwr.bisquare}}, \code{\link{gwr.gauss}}}

\examples{
data(columbus)
gwr.sel(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y))
gwr.sel(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y), gweight=gwr.bisquare)
}
\keyword{spatial}
