\name{Map2Poly4}
\alias{Map2Poly4}

\title{Convert a Map object of polygons to S4 Polylist4 object}
\description{
  Convert a Map object of polygons to S4 Polylist4 object, adding coordinate reference system data.
}
\usage{
Map2Poly4(Map, region.id = NULL, projargs = as.character(NA))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Map}{an S3 "Map" object read from a shapefile.}
  \item{region.id}{unique region ID strings, character vector.}
  \item{projargs}{coordinate reference system data as input to CoRS()}
}

\value{
  a "Polylist4" object
}

\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link{Polylist4-class}}, \code{\link{CoRS-class}}}
\examples{
library(maptools)
x <- read.shape(system.file("shapes/sids.shp", package="maptools")[1])
P4x <- Map2Poly4(x, region.id=x$att.data$FIPSNO,
 projargs="+proj=latlong +datum=NAD27")
proj4string(P4x)
}
\keyword{spatial}
