\name{SpatialGridded-class}
\docType{class}
\alias{SpatialGridded-class}
\alias{show,SpatialGridded-method}
\alias{print.summary.SpatialGridded}
\alias{summary.SpatialGridded}
\alias{getgridindex}
\alias{griddedfn}
\alias{points2grid}

\title{Class "SpatialGridded" ~~~ }
\description{ Spatial class for gridded data; not meant for actual data
but to hold grid coefficients to be used by \link{SpatialCell-class} and
(later on) SpatialRaster-class. }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{gridded(x) = TRUE},
see \link{gridded-methods}. Slots are not meant to be modified directly.
}
\section{Slots}{
  \describe{
    \item{\code{cellcentre.offset}:}{Object of class \code{"numeric"}, length
	dimensions(x); holds the offset coordinate (minimum value) of the grid
	cell centre in each direction }
    \item{\code{cellsize}:}{Object of class \code{"numeric"}, length
	dimensions(x); holds the cell size in each of the directions }
    \item{\code{cells.dim}:}{Object of class \code{"integer"}, length
	(dimensions(x); holds the number of cells in each direction }
    \item{\code{bbox}:}{Object of class \code{"matrix"}, bounding box }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; projection }
  }
}
\section{Extends}{
Class \code{"Spatial"}, directly.
}
\section{Methods}{

The method \link{gridded-methods} tells for any class deriving from
Spatial whether it is gridded or not; the assignment function
\link{"gridded<-"} promotes a SpatialPoints to a SpatialCell,
or a SpatialPointsDataFrame to a SpatialCellDataFrame.
}
\references{  }
\author{ Edzer J. Pebesma, \url{mailto:e.pebesma@geog.uu.nl} }
\note{  
}


\seealso{
  \code{\link{SpatialCell-class}} 
  \code{\link{SpatialCellDataFrame-class}} 
}
\examples{
}
\keyword{classes}
