\name{Polylist4-class}
\docType{class}
\alias{Polylist4-class}
\alias{plot.Polylist4}

\title{Class "Polylist4"}
\description{}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("Polylist4", ...)}.
    
}
\section{Slots}{
  \describe{
    \item{\code{polygons}:}{Object of class \code{"list"} ~~ }
    \item{\code{region.id}:}{Object of class \code{"character"} ~~ }
    \item{\code{within}:}{Object of class \code{"integer"} ~~ }
    \item{\code{bbox}:}{Object of class \code{"matrix"} ~~ }
    \item{\code{proj4string}:}{Object of class \code{"CoRS"} ~~ }
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
  \item{x}{ ~~Describe \code{x} here~~ }
  \item{col}{ ~~Describe \code{col} here~~ }
  \item{border}{ ~~Describe \code{border} here~~ }
  \item{add}{ ~~Describe \code{add} here~~ }
  \item{xlim}{ ~~Describe \code{xlim} here~~ }
  \item{ylim}{ ~~Describe \code{ylim} here~~ }
  \item{\dots}{ ~~Describe \code{\dots} here~~ }
}


\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link{transform.Polylist4-method}}, \code{\link{Polygon4-class}}}
\examples{
library(maptools)
x <- read.shape(system.file("shapes/sids.shp", package="maptools")[1])
P4x <- Map2Poly4(x, region.id=x$att.data$FIPSNO,
 projargs="+proj=latlong +datum=NAD27")
plot(P4x)
}
\keyword{classes}
