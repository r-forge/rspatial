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
Map2Poly4(Map, region.id = NULL, projargs = as.character(NA))
map2Poly4(map)
gpcPoly2P4(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Map}{an S3 "Map" object read from a shapefile using the maptools package.}
  \item{region.id}{unique region ID strings, character vector.}
  \item{projargs}{coordinate reference system data as input to CRS()}
  \item{map}{an S3 "map" object from the maps package}
  \item{x}{an S4 "gpc.poly" object from the gpclib package - see \code{example(holepolys)}}
}

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
