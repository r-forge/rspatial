\name{SpatialRings-class}
\docType{class}
\alias{SpatialRings-class}

\title{Class "SpatialRings" ~~~ }
\description{  class to hold polygon topology (without attributes) }
\section{Objects from the Class}{
Objects can be created by calls to the function \link{SpatialRings}
}
\section{Slots}{
  \describe{
    \item{\code{polygons}:}{Object of class \code{"list"}; list elements are
	all of class \link{Srings-class}}
    \item{\code{plotOrder}:}{Object of class \code{"integer"}; integer array
	giving the order in which objects should be plotted }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; see \link{Spatial-class} }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; see \link{CRS-class}}
  }
}
\section{Extends}{
Class \code{"Spatial"}, directly.
}
\section{Methods}{
No methods defined with class "SpatialRings" in the signature.
}
\references{ }
\author{ Roger Bivand }
\note{ }
\seealso{ \link{SpatialRings} }
\examples{
}
\keyword{classes}
