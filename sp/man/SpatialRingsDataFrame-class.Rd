\name{SpatialRingsDataFrame-class}
\docType{class}
\alias{SpatialRingsDataFrame-class}
\alias{[,SpatialRingsDataFrame-method}
\alias{as.data.frame.SpatialRingsDataFrame}
\alias{coerce,SpatialRingsDataFrame,data.frame-method}

\alias{getSRSringsIDSlots}
\alias{getSRSringsLabptSlots}
\alias{getSRnParts}
\alias{getSRplotOrderSlot}
\alias{getSRpolygonsSlot}
\alias{getSringAreaSlot}
\alias{getSringCoordsSlot}
\alias{getSringLabptSlot}
\alias{getSringsIDSlot}
\alias{getSringsLabptSlot}
\alias{getSringsSringsSlot}
\alias{getSringsplotOrderSlot}

\title{Class "SpatialRingsDataFrame" }
\description{ class to hold polygons with attributes }
\section{Objects from the Class}{
Objects can be created by calls to the function \link{SpatialRingsDataFrame}
}
\section{Slots}{
  \describe{
    \item{\code{data}:}{Object of class \code{"data.frame"}; attribute table }
    \item{\code{polygons}:}{Object of class \code{"list"}; see \link{SpatialRings-class} }
    \item{\code{plotOrder}:}{Object of class \code{"integer"}; see \link{SpatialRings-class} }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; see \link{Spatial-class}}
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; see \link{CRS-class}}
  }
}
\section{Extends}{
Class \code{"SpatialRings"}, directly.
Class \code{"Spatial"}, by class \code{"SpatialRings"}.
}
\section{Methods}{
No methods defined with class "SpatialRingsDataFrame" in the signature.
}
\references{ }
\author{ }
\note{ }

\seealso{
	\link{SpatialRings-class}
}
\examples{
}
\keyword{classes}
