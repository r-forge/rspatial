\name{gwr}
\alias{gwr}
\alias{print.gwr}
\title{Geographically weighted regression}
\description{
The function implements the basic geographically weighted regression approach
to exploring spatial non-stationarity for given global bandwidth and chosen
weighting scheme.
}
\usage{
gwr(formula, data=list(), coords, bandwidth, gweight=gwr.gauss, 
	adapt=NULL, hatmatrix = FALSE, fit.points)
print.gwr(x, ...)
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
  \item{adapt}{either NULL (default) or a proportion between 0 and 1 of observations to include in weighting scheme (k-nearest neighbours)}
  \item{hatmatrix}{}
  \item{fit.points}{}
  \item{x}{}
  \item{...}{}
}
\details{
The function applies the weighting function in turn to each of the 
observations, or fit points if given, calculating a weighted regression 
for each point. The
results may be explored to see if coefficient values vary over space.
}
\value{
  \item{SDF}{a SpatialDataFrame (may be gridded) or SpatialDataFramePolygons object (see package "sp") with fit.points, weights, GWR coefficient estimates, R-squared, and coefficient standard errors in its "data" slot.}
  \item{lhat}{Leung et al. L matrix}
  \item{lm}{Ordinary least squares global regression on the same model formula.}  \item{bandwidth}{the bandwidth used.}
  \item{this.call}{the function call used.}
}
\references{Fotheringham, A.S., Brunsdon, C., and Charlton, M.E., 2000,
Quantitative Geography, London: Sage; C. Brunsdon, A.Stewart Fotheringham
and M.E. Charlton, 1996, "Geographically Weighted Regression: A Method for
Exploring Spatial Nonstationarity", Geographical Analysis, 28(4), 281-298;
\url{http://www.ncl.ac.uk/~ngeog/GWR/}}
\author{Roger Bivand \email{Roger.Bivand@nhh.no}}


\seealso{\code{\link{gwr.sel}}, \code{\link{gwr.gauss}},
\code{\link{gwr.bisquare}}}

\examples{
data(columbus)
col.lm <- lm(crime ~ income + housing, data=columbus)
summary(col.lm)
col.bw <- gwr.sel(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y))
col.gauss <- gwr(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y), bandwidth=col.bw, hatmatrix=TRUE)
col.gauss
col.d <- gwr.sel(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y), gweight=gwr.bisquare)
col.bisq <- gwr(crime ~ income + housing, data=columbus,
  coords=cbind(columbus$x, columbus$y), bandwidth=col.d, 
  gweight=gwr.bisquare, hatmatrix=TRUE)
col.bisq
data(georgia)
g.adapt.gauss <- gwr.sel(PctBach ~ TotPop90 + PctRural + PctEld + PctFB + PctPov + PctBlack, data=georgia, adapt=TRUE)
res.adpt <- gwr(PctBach ~ TotPop90 + PctRural + PctEld + PctFB + PctPov + PctBlack, data=georgia, adapt=g.adapt.gauss)
res.adpt
pairs(as(res.adpt$SDF, "data.frame")[,1:11], pch=".")
plot(res.adpt$SDF, "PctBlack", breaks=c(-0.25, 0, 0.01, 0.025, 0.075), 
 col=grey(5:2/6))
g.bw.gauss <- gwr.sel(PctBach ~ TotPop90 + PctRural + PctEld + PctFB + PctPov + PctBlack, data=georgia)
res.bw <- gwr(PctBach ~ TotPop90 + PctRural + PctEld + PctFB + PctPov + PctBlack, data=georgia, bandwidth=g.bw.gauss)
res.bw
pairs(as(res.bw$SDF, "data.frame")[,1:11], pch=".")
plot(res.bw$SDF, "PctBlack", breaks=c(-0.25, 0, 0.01, 0.025, 0.075), 
 col=grey(5:2/6))
}
\keyword{spatial}

