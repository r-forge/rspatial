\name{Polygon4-class}
\docType{class}
\alias{Polygon4-class}

\title{Class "Polygon4" for map polygons}
\description{(Multi) polygon map objects}
\section{Objects from the Class}{
Objects will not usually be created by calls of the form \code{new("Polygon4", ...)}. They will usually come from construction functions making objects from imported foreign data. If the polygons has multiple parts, then the coordinates for each part are separated by NA.
}
\section{Slots}{
  \describe{
    \item{\code{coords}:}{Object of class \code{"matrix"} polygon coordinates}
    \item{\code{nVerts}:}{Object of class \code{"integer"} number of vertices}
    \item{\code{nParts}:}{Object of class \code{"integer"} number of member polygons}
    \item{\code{pStart.from}:}{Object of class \code{"integer"} pointers to member polygon starts}
    \item{\code{pStart.to}:}{Object of class \code{"integer"} pointers to member polygon ends}
    \item{\code{RingDir}:}{Object of class \code{"integer"} directions of polygon rings (shapelib, possibly wrong)}
    \item{\code{ringDir}:}{Object of class \code{"integer"} directions of polygon rings}
    \item{\code{region.id}:}{Object of class \code{"character"} unique region ID}
    \item{\code{bbox}:}{Object of class \code{"matrix"} bounding box of polygon}
    \item{\code{proj4string}:}{Object of class \code{"CRS"} projection string description (may be NA)}
  }
}
\section{Extends}{
Class \code{"SpatialData"}, directly.
}


\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link{Polylist4-class}}, \code{\link{CRS-class}}}

\examples{

}
\keyword{classes}
