\name{select.spatial}
\alias{select.spatial}
\title{ select points spatially }
\description{
select a number of points by digitizing the area they fall in
}
\usage{
select.spatial(data, digitize = TRUE, pch = "+")
}
\arguments{
\item{data}{data object of class, or extending \code{SpatialDataFrame};
this object knows about its x and y coordinate }
\item{digitize}{ logical; if TRUE, points in a digitized polygon
are selected; if FALSE, points identified by mouse clicks are selected }
\item{pch}{plotting character used for points}
}
\value{ array with indexes (row numbers) of points inside
the digitized polygon.}
\seealso{\link{point.in.polygon}, \link{locator}, \link{SpatialDataFrame-class}}
\examples{
data(meuse)
## the following command requires user interaction: left mouse
## selects points, right mouse ends digitizing
data(meuse)
coordinates(meuse) = c("x", "y")
# select.spatial(meuse)
}
\keyword{models}
