\name{Polylist4-class}
\docType{class}
\alias{Polylist4-class}
\alias{plot.Polylist4}

\title{Class "Polylist4" for map polygons}
\description{List of map polygon objects}
\section{Objects from the Class}{
Objects will not usually be created by calls of the form \code{new("Polylist4", ...)}. They will usually come from construction functions making objects from imported foreign data. 
    
}
\section{Slots}{
  \describe{
    \item{\code{polygons}:}{Object of class \code{"list"} list of objects of class \code{"Polygon4"}}
    \item{\code{region.id}:}{Object of class \code{"character"} unique region IDs}
    \item{\code{within}:}{Object of class \code{"integer"} as yet unused vector to indicate which other polygons include each polygon}
    \item{\code{bbox}:}{Object of class \code{"matrix"} bounding box of polygons}
    \item{\code{proj4string}:}{Object of class \code{"CRS"} projection string description (may be NA)}
  }
}
\section{Extends}{
Class \code{"SpatialData"}, directly.
}

\usage{
plot.Polylist4(x, col = NA, border = par("fg"), add = FALSE, xlim = NULL, ylim = NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{\code{"Polylist4"} object}
  \item{col}{polygon fill colour}
  \item{border}{border colour}
  \item{add}{add to existing plot}
  \item{xlim, ylim}{numeric of length 2, giving the x and y coordinates ranges}
  \item{\dots}{graphical parameters can be given as arguments to \code{plot}}
}


\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link{Polygon4-class}}}
\examples{
data(ncMap)
P4x <- Map2Poly4(nc.Map, region.id=nc.Map$att.data$FIPSNO)
plot(P4x)
}
\keyword{classes}
