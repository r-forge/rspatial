\name{polygons}
\alias{polygons}
\alias{polygons<-}
\alias{verifyPolygon}

\title{Create a SpatialDataPolygons object, or retrieve polygon values }
\description{
Creates a SpatialDataPolygons, a data.frame
with polygon information, or retrieves polygons. The polygons are held in a Polylist4 object.
}
\usage{
polygons(obj) <- value
polygons(obj) 
verifyPolygon(x)
}
\arguments{
  \item{obj}{ when setting polygons, a data.frame; when retrieving polygons, an object of class SpatialDataPolygons. }
  \item{value}{ an object of class Polylist4 }
  \item{x}{an object, preferably a two column numeric matrix of coordinates for a 2D polygon}
}
\value{
  An object of class \code{SpatialDataPolygons}; see
  \code{\link{SpatialDataPolygons-class}}.
}

\details{ 
}
\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }

\seealso{\code{\link{Polylist4-class}}}

\examples{
data(ncMap)
P4x <- Map2Poly4(nc.Map, region.id=nc.Map$att.data$FIPSNO)
x <- nc.Map$att.data
class(x)
polygons(x) <- P4x
class(x)
summary(x)
}

\keyword{spatial}
