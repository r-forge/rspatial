\name{cbindSDFP}
\alias{cbindSDFP}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Combine "SpatialDataFramePolygons" with data frame}
\description{
 The function combines a "SpatialDataFramePolygons" object with a data frame object column-wise, returning a "SpatialDataFramePolygons" object.
}
\usage{
cbindSDFP(SDFP, DF)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SDFP}{an object of class "SpatialDataFramePolygons"}
  \item{DF}{an object of class "data.frame"}
}
\value{
  an object of class "SpatialDataFramePolygons" with extra columns bound column-wise to the input object of that class
}

\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link{SpatialDataFramePolygons-class}}}

\examples{
data(ncMap)
x <- nc.Map$att.data
class(x)
coordinates(x) <- c("x", "y")
class(x)
P4x <- Map2Poly4(nc.Map, region.id=nc.Map$att.data$FIPSNO)
Polygons(x) <- P4x
class(x)
f.x <- cut(x@data$x, breaks=c(-90, -80, -70))
xx <- cbindSDFP(x, data.frame(f.x))
class(xx)
summary(xx)
plot(xx, "f.x", col=c("red", "blue"))
}
\keyword{spatial}
