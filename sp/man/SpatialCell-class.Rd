\name{SpatialCell-class}
\docType{class}
\alias{SpatialCell-class}
\alias{[,SpatialCell-method}
\alias{SpatialCell}
\alias{plot.SpatialCell}
\alias{print.summary.SpatialCell}
\alias{summary.SpatialCell}

\title{Class "SpatialCell" ~~~ }
\description{  extends SpatialPoints for the case when the points are
on a rectangular, spatial grid. }
\section{Objects from the Class}{
Objects are created by using e.g. 

gridded(x) = TRUE

see \link{gridded-methods}
}
\section{Slots}{
  \describe{
    \item{\code{grid}:}{Object of class \code{"SpatialGridded"}; grid parameters }
    \item{\code{grid.index}:}{Object of class \code{"integer"}; index how to
	go from a Cell representation (columns with coordinates) to a matrix 
	representation (not yet functioning) }
    \item{\code{coords}:}{Object of class \code{"matrix"}; coordinate values }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; bounding box }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; projection  }
  }
}
\section{Extends}{
Class \code{"SpatialPoints"}, directly.
Class \code{"Spatial"}, by class \code{"SpatialPoints"}.
}
\section{Methods}{
 \describe{
   \item{[}{\code{signature(x = "SpatialCell")}: subset rows}
 }
}
\references{ }
\author{ Edzer J. Pebesma, \url{mailto:e.pebesma@geog.uu.nl} }
\note{  }

\seealso{
  \code{\link{SpatialGridded-class}}
}
\examples{
x <- c(1,1,1,2,2,2,3,3,3)
y <- c(1,2,3,1,2,3,1,2,3)
xy <- cbind(x,y)
S <- SpatialPoints(xy)
gridded(S) <- TRUE
gridded(S)
class(S)
gridded(S) <- FALSE
gridded(S)
class(S)
}
\keyword{classes}
