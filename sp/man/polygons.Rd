\name{polygons}
\alias{polygons}
\alias{polygons<-}

\title{Create a SpatialDataPolygons object, or retrieve polygon values }
\description{
Creates a SpatialDataPolygons, a data.frame
with polygon information, or retrieves polygons
}
\usage{
polygons(obj) <- value
polygons(obj) 
}
\arguments{
  \item{obj}{ when setting polygons, a data.frame or an existing object
  with the value NULL; when retrieving polygons, an object of class
  SpatialDataPolygons. }
  \item{value}{ a list with polygons; the length of the list should
  equal the number of rows in obj (if not NULL), and each polygon should
  be valid; See below. }
}
\value{
  An object of class \code{SpatialDataPolygons}; see
  \code{\link{SpatialDataPolygons-class}}.
}

\details{ Valid polygons are matrices with two columns and at least
four rows; first column is taken as the x-coordinates, second column
as the y-coordinate. Polygons shoud be closed, meaning that the first
point should equal the last.
}
\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }

\seealso{ }

\examples{
x = data.frame(x = c(1,2,3), y = c(4,5,6))
pol1 = cbind(x=c(1,1,2,1),y=c(1,2,1,1)) # closed
polygon.valid = list(pol1, pol1, pol1)
polygons(x) = polygon.valid
summary(x)
}

\keyword{spatial}
