\name{gwr.mc}
\alias{gwr.mc}
\title{Random permutations of observations for geographically weighted regression}
\description{
The function does \code{nsim} random permutations of the model data, returning the rank in \code{nsim+1} of the observed \eqn{b_{ik}} values over the simulations carried out. Values in the tails (high or low ranks) indicate possible local anomalies.
}
\usage{
gwr.mc(formula, data=list(), coords, bandwidth, gweight=gwr.gauss, nsim)
}
\arguments{
  \item{formula}{regression model formula as in \code{lm}}
  \item{data}{model data frame as in \code{lm}}
  \item{coords}{matrix of coordinates of points representing the spatial
  positions of the observations}
  \item{bandwidth}{bandwidth used in the weighting function, possibly
  calculated by \code{gwr.cv}}
  \item{gweight}{geographical weighting function, at present only
  \code{gwr.gauss()} or \code{gwr.bisquare()}}
  \item{nsim}{number of simulations to carry out}
}
\value{
  \item{this.call}{the function call used.}
  \item{nsim}{number of simulations carried out}
  \item{bandwidth}{bandwidth used}
  \item{ranks}{a matrix of the ranks of the observed model coefficient estimates in the distributions of simulated estimates}
}
\references{Fotheringham, A.S., Brunsdon, C., and Charlton, M.E., 2000,
Quantitative Geography, London: Sage; C. Brunsdon, A.Stewart Fotheringham
and M.E. Charlton, 1996, "Geographically Weighted Regression: A Method for
Exploring Spatial Nonstationarity", Geographical Analysis, 28(4), 281-298;
\url{http://www.ncl.ac.uk/~ngeog/GWR/}}
\author{Roger Bivand \email{Roger.Bivand@nhh.no}}
\seealso{\code{\link{gwr}}}

\examples{
data(columbus)
col.bw <- gwr.sel(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y))
col.gauss <- gwr(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y), bandwidth=col.bw)
col.sim <- gwr.mc(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y), bandwidth=col.bw, nsim=99)
col.sim$ranks
#m <- ncol(col.gauss$gwr.b)
#plot(columbus$x, columbus$y, asp=1, pch=".", xlab="", ylab="")
#for(i in 1:m) {
#  low <- which(col.sim$ranks[,i] < 10)
#  high <- which(col.sim$ranks[,i] > 90)
#  if(length(low) > 0) points(columbus$x[low], columbus$y[low], col=1, pch=i)
#  if(length(high) > 0) points(columbus$x[high], columbus$y[high], col=2, pch=i)
#}
#legend(c(23.45, 31.8), c(41.1, 47.4), legend=c(paste(colnames(col.gauss$gwr.b),
#  "[low]"), paste(colnames(col.gauss$gwr.b), "[high]")),
#  col=c(rep(1, m), rep(2, m)), pch=rep(1:m, 2))
}

\keyword{spatial}

