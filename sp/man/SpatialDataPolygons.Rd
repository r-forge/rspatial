\name{SpatialDataPolygons}
\alias{SpatialDataPolygons}
\alias{getMeanDF}
%\alias{summary.SpatialDataPolygons}
\alias{verifyPolygon}
\alias{map2polys}

\title{Create a SpatialDataPolygons object }
\description{ Creates a SpatialDataPolygons object, a data frame where
each row is associated with a spatial polygon }
\usage{
SpatialDataPolygons(data, polygons)
getMeanDF(polygons)
verifyPolygon(x)
%summary.SpatialDataPolygons(object, ...)
map2polys(map)
}
\arguments{
  \item{data}{ An object of class data.frame }
  \item{polygons}{ a list of polygons}
  \item{x}{ a single polygon }
%  \item{object}{ an object of class SpatialDataPolygons }
  \item{map}{ an object of class "map", see library maps }
  \item{...}{ ignored }
}
\value{ SpatialDataPolygons returns an object of class
\link{SpatialDataPolygons-class}; 

getMeanDF calculates the means of x and y coordinates, and adds them to
the attribute table.

verifyPolygons does some very basic verification checks on each polygon.

summary.SpatialDataPolygons prints a simple summary of a
SpatialDataPolygons object.

map2polys converts objects from the maps library to a list of 2-column
polygons.

}

\details{ }

\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }

\seealso{ \link{SpatialDataPolygons-class}, 
\link{SpatialData-class}, \link{polygons} }

\examples{
}

\keyword{spatial}
