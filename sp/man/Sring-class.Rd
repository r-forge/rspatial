\name{Sring-class}
\docType{class}
\alias{Sring-class}

\title{Class "Sring" }
\description{ class for spatial polygon }
\section{Objects from the Class}{
Objects can be created by calls to the function \code{Sring}
}
\section{Slots}{
  \describe{
    \item{\code{ringDir}:}{Object of class \code{"integer"}; RSB }
    \item{\code{labpt}:}{Object of class \code{"numeric"}; RSB }
    \item{\code{area}:}{Object of class \code{"numeric"}; RSB }
    \item{\code{coords}:}{Object of class \code{"matrix"}; coordinates of the polygon;
	first point should equal the last point }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; see \link{Spatial-class} }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; see \link{CRS-class} }
  }
}
\section{Extends}{
Class \code{"Sline"}, directly.
Class \code{"Spatial"}, by class \code{"Sline"}.
}
\section{Methods}{
No methods defined with class "Sring" in the signature.
}
\references{ }
\author{ Roger Bivand }
\note{ }

\seealso{
	\link{Srings-class}, \link{SpatialRings-class}
}
\examples{
##---- Should be DIRECTLY executable !! ----
}
\keyword{classes}
