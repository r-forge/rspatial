\name{SpatialDataFrameGrid-class}
\docType{class}
\alias{SpatialDataFrameGrid-class}
\alias{[,SpatialDataFrameGrid-method}
\alias{"[.SpatialDataFrameGrid"}
\alias{coerce,SpatialDataFrame,SpatialDataFrameGrid-method}
\alias{coerce,SpatialDataFrameGrid,SpatialDataFrame-method}
\alias{coerce,SpatialDataFrameGrid,data.frame-method}
\alias{as.data.frame.SpatialDataFrameGrid}

\title{Class "SpatialDataFrameGrid" ~~~ }
\description{  ~~ A concise (1-5 lines) description of what the class is.  ~~}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("SpatialDataFrameGrid", ...)}, but more easily by using the function \link{gridded<-}
}
\section{Slots}{
  \describe{
    \item{\code{cellcentre.offset}:}{Object of class \code{"numeric"};
	holds the coordinates (2 or 3D) of the cell centre with the smallest
	coordinate value in x, y and (possibly) z }
    \item{\code{cellsize}:}{Object of class \code{"numeric"}; holds
	the cell size in x, y and (possibly) z direction }
    \item{\code{cells.dim}:}{Object of class \code{"integer"}; holds
	the number of cells in x, y and (possibly) z direction }
    \item{\code{data}:}{Object of class \code{"data.frame"};
	see \link{SpatialDataFrame-class}}
    \item{\code{coord.names}:}{Object of class \code{"character"};
	see \link{SpatialDataFrame-class}}
    \item{\code{coord.columns}:}{Object of class \code{"integer"};
	see \link{SpatialDataFrame-class}}
    \item{\code{bbox}:}{Object of class \code{"matrix"};
	see \link{SpatialData-class} }
    \item{\code{proj4string}:}{Object of class \code{"CoRS"};
	see \link{SpatialData-class} }
  }
}
\section{Extends}{
Class \code{"SpatialDataFrame"}, directly.
Class \code{"SpatialData"}, by class \code{"SpatialDataFrame"}.
}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "SpatialDataFrame", to = "SpatialDataFrameGrid")}: adds (and auto-detects) the grid topology information }
    \item{coerce}{\code{signature(from = "SpatialDataFrameGrid", to = "SpatialDataFrame")}: removes the grid topology information }
    \item{coerce}{\code{signature(from = "SpatialDataFrameGrid", to = "data.frame")}: removes all spatial topology attributes }
  }
}
\references{ }
\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }
\note{  }

\seealso{ \link{gridded}, \link{SpatialDataFrame-class}, \link{coordinates} }
\examples{
# see \link{gridded}
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE
image(meuse.grid[1:1000, "dist"])
}
\keyword{classes}
