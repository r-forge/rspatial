\name{SpatialCellDataFrame-class}
\docType{class}
\alias{SpatialCellDataFrame-class}
\alias{[,SpatialCellDataFrame-method}
\alias{SpatialCellDataFrame}
\alias{plot.SpatialCellDataFrame}
\alias{print.summary.SpatialCellDataFrame}
\alias{summary.SpatialCellDataFrame}
\alias{coerce,SpatialCellDataFrame,SpatialPointsDataFrame-method}
\alias{coerce,SpatialCellDataFrame,data.frame-method}
\alias{as.data.frame.SpatialCellDataFrame}

\title{Class "SpatialCellDataFrame" ~~~ }
\description{  Class for spatial attributes that have spatial locations
on a regular grid. }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{gridded(x) <- TRUE},
where \code{x} is of class \link{SpatialPointsDataFrame-class}.
}
\section{Slots}{
  \describe{
    \item{\code{data}:}{Object of class \code{"data.frame"}; attribute data }
    \item{\code{grid}:}{Object of class \code{"SpatialGridded"}; grid parameters }
    \item{\code{grid.index}:}{Object of class \code{"integer"}; index to go from
	coordinates to a matrix representation }
    \item{\code{coords}:}{Object of class \code{"matrix"}; coordinate matrix }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; bounding box }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; projection }
  }
}
\section{Extends}{
Class \code{"SpatialCell"}, directly.
Class \code{"SpatialPoints"}, by class \code{"SpatialCell"}.
Class \code{"Spatial"}, by class \code{"SpatialCell"}.
}
\section{Methods}{
  \describe{
    \item{[}{\code{signature(x = "SpatialCellDataFrame")}: ... }
  }
}
\references{  }
\author{ Edzer J. Pebesma, \url{mailto:e.pebesma@geog.uu.nl} }
\note{  }

\seealso{
  \code{\link{SpatialCell-class}}, which does not contain the attribute data
}
\examples{
data(meuse.grid)
coordinates(meuse.grid) = c("x", "y")
gridded(meuse.grid) <- TRUE
}
\keyword{classes}
