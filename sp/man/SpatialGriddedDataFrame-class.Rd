\name{SpatialGriddedDataFrame-class}
\docType{class}
\alias{SpatialGriddedDataFrame-class}
\alias{[,SpatialGriddedDataFrame-method}
\alias{[[,SpatialGriddedDataFrame-method}
\alias{[[<-,SpatialGriddedDataFrame-method}
\alias{SpatialGriddedDataFrame}
\alias{plot.SpatialGriddedDataFrame}
\alias{print.summary.SpatialGriddedDataFrame}
\alias{summary.SpatialGriddedDataFrame}
\alias{coerce,SpatialGriddedDataFrame,SpatialPointsDataFrame-method}
\alias{coerce,SpatialGriddedDataFrame,data.frame-method}
\alias{as.data.frame.SpatialGriddedDataFrame}
\alias{as.SpatialGriddedDataFrame.SpatialCellDataFrame}

\title{Class "SpatialGriddedDataFrame" ~~~ }
\description{  Class for spatial attributes that have spatial locations
on a regular grid. }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{as(x,
"SpatialGriddedDataFrame")}, where \code{x} is of class
\link{SpatialCellDataFrame-class}, or by importing through rgdal.  
In contrast to objects of class \link{SpatialCellDataFrame-class},
ordered full grids are stored instead of unordered non-NA cells; 
this makes it obsolete to explicitly store coordinates, as they
are derived from grid topology.  }

\section{Slots}{
  \describe{
    \item{\code{data}:}{Object of class \code{"data.frame"}; attribute data }
    \item{\code{centre.offset}:}{see \link{SpatialGridded}; grid parameters }
    \item{\code{cellsize}:}{see \link{SpatialGridded}; grid parameters }
    \item{\code{cellsidim}:}{see \link{SpatialGridded}; grid parameters }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; bounding box }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; projection }
  }
}
\section{Extends}{
Class \code{"SpatialGridded"}, directly.
Class \code{"Spatial"}, by class \code{"SpatialGridded"}.
}
\section{Methods}{
  \describe{
    \item{coordinates}{\code{signature(x = "SpatialGriddedDataFrame")}: retrieves (and calculates!) coordinates }
    \item{[}{\code{signature(x = "SpatialGriddedDataFrame")}: selects single attribute, and returns an
	object of class \code{SpatialGriddedDataFrame}}
    \item{[[}{\code{signature(x = "SpatialGriddedDataFrame")}: retrieves an attribute, dropping everything 
	else (topology) }
    \item{[[<-}{\code{signature(x = "SpatialGriddedDataFrame")}: assigns or replaces an attribute }
  }
}

\references{  }
\author{ Edzer J. Pebesma, \url{mailto:e.pebesma@geog.uu.nl} }
\note{  }

\seealso{
  \code{\link{SpatialGridded-class}}, which does not contain the attribute data
}
\examples{
data(meuse.grid) # only the non-missing valued cells
coordinates(meuse.grid) = c("x", "y") # promote to SpatialPointsDataFrame
gridded(meuse.grid) <- TRUE # promote to SpatialCellDataFrame
x = as(meuse.grid, "SpatialGriddedDataFrame") # creates the full grid
x[["idist"]] = 1 - x[["dist"]] # assigns new attribute
image(x["idist"])
}
\keyword{classes}
