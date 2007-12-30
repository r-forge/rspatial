\name{relrisk}

\alias{relrisk}

\title{Compute relative ratio of spatial kernel density estimates.}

\description{
 Calculates the log2 of the ratio of two spatial kernel density estimates
- this is equivalent to kernel binary regression on the point labels as
described in Kelsall&Diggle(1998). It is default - and recommended - to
use the same bandwidth parameter in both numerator and denominator.
}


\usage{
relrisk(pts1, pts2, poly, h1, h2 = h1, grid = TRUE, ngrid = 500,
                    points = NA, kernel = "normal")
}

\arguments{
\item{pts1}{A point dataset (numerator).}
\item{pts2}{A point dataset (denominator).}
\item{poly}{A polygon containing all the data points.}
\item{h1}{A bandwidth parameter to be used with pts1.}
\item{h2}{A bandwidth parameter to be used with pts2.}
\item{grid}{Logical value. If true the estimate is evaluated on a grid, if
false it is evaluated in the points given in points.} 
\item{ngrid}{Approximate number of grid points required. Used to construct grid.}
\item{points}{A point dataset. If grid=FALSE the estimate is evaluated in these points.}
\item{kernel}{Choice of kernel (either "normal" or "quartic").}
}
\examples{

data(southlancs)

cases<-southlancs.pts[southlancs$cc==1,]
controls<-southlancs.pts[southlancs$cc==0,]
rr<-relrisk(cases, controls, southlancs.bdy, 1700, 1700, grid=TRUE, ngrid=1000)

image(rr)
contour(rr$x, rr$y, rr$z, add = TRUE, drawlabels = TRUE)

}

\references{
Kelsall, J.E. and Diggle, P.J. (1995). Nonparametric-estimation of spatial variation in relative risk. Statistics in Medicine, 14:2335–2342.

Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of disease:
A nonparametric binary regression approach. Applied Statistics, 47(4):559-573.
}


\keyword{}

