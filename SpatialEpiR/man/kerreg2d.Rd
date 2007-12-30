\name{kerreg2d}
\alias{kerreg2d}

\title{Two-dimensional weighted kernel regression.}

\description{
Calculates a two-dimensional weighted kernel regression of the y values at
the locations given by pts.
}


\usage{
kerreg2d(pts, h, y, w = rep(1, length(y)), poly = NA, x = pts,
                     grid = FALSE, ngrid= 1000)
}

\arguments{
\item{pts}{A point dataset.}
\item{h}{A bandwidth parameter.}
\item{y}{A vector of values to be smoothed.}
\item{w}{A vector of weights. Default gives the same weight to all observations
.}
\item{poly}{A polygon containing the points in pts - only used if grid=TRUE.}
\item{x}{A point dataset which indicates were the fitted surface should be evaluated. The default is just using the point dataset given by pts.}
\item{grid}{Logical value. If true a regular grid is constructed within poly
and the surface is evaluated on this instead of at the points given by the
points in x.}
\item{ngrid}{Approximate number of points to use if grid=TRUE.}
}

\examples{
data(southlancs)

cases<-southlancs.pts[southlancs.cc==1,]
controls<-southlancs.pts[southlancs.cc==0,]

wcc<-kerreg2d(southlancs.pts, 1700, southlancs.cc, poly=southlancs.bdy,
   grid=TRUE)

image(wcc)
contour(wcc, add=TRUE)
}

\references{

}


\keyword{}
