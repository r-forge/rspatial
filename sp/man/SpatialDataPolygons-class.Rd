\name{SpatialDataPolygons-class}
\docType{class}
\alias{SpatialDataPolygons-class}
\alias{summary.SpatialDataPolygons}
\alias{coerce,SpatialDataPolygons,data.frame-method}
\alias{as.data.frame.SpatialDataPolygons}

\title{Class "SpatialDataPolygons"; stores spatial polygons and attributes  }
\description{ a class for storing a list of polygons and an attribute 
table (data.frame) }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("SpatialDataPolygons", ...)}, or more conveniently with the function \link{polygons}
}
\section{Slots}{
  \describe{
    \item{\code{data}:}{Object of class \code{"data.frame"}, containing
	the attributes of the polygons; the number of rows should match the
	number of polygons }
    \item{\code{polygons}:}{Object of class \code{"list"}; list of length
	nrow(data), each item contains a 2-column matrix containing the x
	and y coordinate of a polygon }
    \item{\code{has.holes}:}{Object of class \code{"logical"}; indicates
	which of the polygons have holes }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; see class
	\link{SpatialData-class} }
    \item{\code{proj4string}:}{Object of class \code{"character"}; see class
	\link{SpatialData-class} }
  }
}
\section{Extends}{
Class \code{"SpatialData"}, directly.
}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "SpatialDataPolygons", to = "data.frame")}: returns the data slot (attribute table) }
  }
}
\references{ }
\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }
\note{ holes are not detected nor handled yet }

\seealso{ \link{polygons}}
\examples{
}
\keyword{classes}
