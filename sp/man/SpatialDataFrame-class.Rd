\name{SpatialDataFrame-class}
\docType{class}
\alias{SpatialDataFrame-class}
\alias{[,SpatialDataFrame-method}
\alias{"[.SpatialDataFrame"}
\alias{coerce,SpatialDataFrame,data.frame-method}
%\alias{coerce,SpatialDataFrame,SpatialDataFrameGrid-method}
\alias{coerce,SpatialDataFrame,SpatialData-method}
%\alias{coerce,SpatialDataFrameGrid,SpatialDataFrame-method}
\alias{show,SpatialDataFrame-method}
\alias{ShowSpatialDataFrame}
\alias{as.SD}
\alias{as.SDF}
\alias{as.SDFgrid}
\alias{as.data.frame.SpatialDataFrame}

\title{Class "SpatialDataFrame" ~~~ }
\description{ a data.frame that knows which columns store spatial coordinates }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("SpatialDataFrame", ...)},
or more easily by using \link{coordinates}
}
\section{Slots}{
  \describe{
    \item{\code{data}:}{Object of class \code{"data.frame"}, contains the
	data concerned }
    \item{\code{coord.names}:}{Object of class \code{"character"}; contains
	coordinate column names in slot data }
    \item{\code{coord.columns}:}{Object of class \code{"integer"}; contains
	coordinate column numbers in slot data }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; 
	see \link{SpatialData-class}  }
    \item{\code{proj4string}:}{Object of class \code{"CoRS"}; 
	see \link{SpatialData-class}  }
  }
}
\section{Extends}{
Class \code{"SpatialData"}, directly.
}
\section{Methods}{
  \describe{
    \item{[}{\code{signature(x = "SpatialDataFrame")}: selects rows and/or
	columns on a SpatialDataFrame; returns a SpatialDataFrame that always contains
	the coordinates, whether explicitly selected or not. (If you do not want this,
	consider first coercing to a data.frame.) See notes below.  }
    \item{coerce}{\code{signature(from = "SpatialDataFrame", to = "data.frame")}: removes all information on coordinates, and returns slot data }
    \item{coerce}{\code{signature(from = "SpatialDataFrame", to = "SpatialDataFrameGrid")}: auto-detects the grid topology (cell size, nr of rows/cols/layers,
	cell offset) and will error if data is not gridded }
    \item{coerce}{\code{signature(from = "SpatialDataFrame", to = "SpatialData")}: probably useless, as SpatialData is only a container }
    \item{coerce}{\code{signature(from = "SpatialDataFrameGrid", to = "SpatialDataFrame")}: removes the grid topology info }
    \item{show}{\code{signature(object = "SpatialDataFrame")}: prints a 
	SpatialDataFrame }
  }
}
\references{ originally heavily inspired by 
spatial.data.frame, in r-asp, by Barry Rowlinson }
\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }
\note{ A note on selecting a SpatialDataFrmame with \code{[.SpatialDataFrame}:
(i) behaviour should be intuitively that of selection on data.frame's, subject
to (ii) resulting SpatialDataFrames should always have their coordinates
(and coordinate settings) preserved. For that reason, \code{drop=TRUE} will
not work.  }

\seealso{ \link{coordinates}, \link{SpatialData-class}, 
\link{SpatialDataFrameGrid-class},
\link{SpatialDataPolygons-class}
}
\examples{
# see examples for functions coordinates and coordinates<-
data(meuse)
meuse <- meuse[1:3, ] # be brief
coordinates(meuse) <- ~x+y
meuse[1:2,] # selects rows 1 and 2
meuse[1:2,1:5]
meuse[,4:5] # coordinates + column 4 and 5
meuse["zinc"] # selects column
meuse[c("x", "zinc","copper","zinc")] # will modify second zinc name, but not x
meuse[1:2, "zinc"]
meuse[c("y","x")] # column order will be reversed!
}
\keyword{classes}
