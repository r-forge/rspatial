\name{Map2Poly4}
\alias{Map2Poly4}
\alias{map2Poly4}
\alias{gpcPoly2P4}

\title{Convert a Map object of polygons to S4 Polylist4 object}
\description{
  Convert a Map object of polygons to S4 Polylist4 object, 
  adding coordinate reference system data.
}
\usage{
Map2Poly4(Map, region.id = NULL, projargs = as.character(NA), raw=FALSE)
map2Poly4(map)
gpcPoly2P4(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Map}{an S3 "Map" object read from a shapefile using the maptools package.}
  \item{region.id}{unique region ID strings, character vector.}
  \item{raw}{default FALSE: perform sanity check on rings with hole direction but not surrounded by any other polygon; TRUE no check}
  \item{projargs}{coordinate reference system data as input to CRS()}
  \item{map}{an S3 "map" object from the maps package}
  \item{x}{an S4 "gpc.poly" object from the gpclib package - see \code{example(holepolys)}}
}

\details{\code{Map2Poly4} tries to make adjustments to suit the ESRI shapefile stipulations: \url{http://shapelib.maptools.org/dl/shapefile.pdf}: "The order of vertices or orientation for a ring indicates which side of the ring is the interior of the polygon. The neighborhood to the right of an observer walking along the ring in vertex order is the neighborhood inside the polygon. Vertices of rings defining holes in polygons are in a counterclockwise direction. Vertices for a single, ringed polygon are, therefore, always in clockwise order" (p.8). If raw=FALSE, an additional attempt is made to enforce the final stipulation, where the polygon's bounding box does not fall wholly inside the bounding box of another polygon. This may generate warnings indicating when this has taken place, indicating an unexpected ring direction in the imported shapefile.}

\value{
  a "Polylist4" object
}

\author{Roger Bivand \email{Roger.Bivand@nhh.no}, Edzer Pebesma}

\seealso{\code{\link{Polylist4-class}}, \code{\link{CRS-class}}}
\examples{
if (require(maps)) {
  it <- map2Poly4(map("italy", plot=FALSE))
  class(it)
  plot(it, col=2:11)
}
}
\keyword{spatial}
