\name{Polygons<-}
\alias{Polygons}
\alias{Polygons<-}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Create a SpatialDataFramePolygons object, or retrieve polygon values}
\description{
  Creates a SpatialDataFramePolygons, a SpatialDataFrame
with polygon information, or retrieves polygons. The polygons are held in a Polylist4 object.
}
\usage{
Polygons<-(obj, value)
Polygons(obj)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{ when setting polygons, a data.frame or an existing object
  with the value NULL; when retrieving polygons, an object of class
  SpatialDataPolygons. }
  \item{value}{ an object of class Polylist4 }
}
\value{
   An object of class \code{SpatialDataFramePolygons}; see
  \code{\link{SpatialDataFramePolygons-class}}.
}
\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link{SpatialDataFrame-class}}, \code{\link{Polylist4-class}}}
\examples{
data(ncMap)
P4x <- Map2Poly4(nc.Map, region.id=nc.Map$att.data$FIPSNO)
x <- nc.Map$att.data
class(x)
coordinates(x) <- c("x", "y")
class(x)
Polygons(x) <- P4x
class(x)
summary(x)
}
\keyword{spatial}
