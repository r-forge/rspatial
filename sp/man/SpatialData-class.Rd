\name{SpatialData-class}
\docType{class}
\alias{SpatialData-class}
\alias{print.summary.SpatialData}
\alias{summary.SpatialData}
% \alias{coerce,SpatialDataFrame,SpatialData-method}

\title{Class "SpatialData" ~~~ }
\description{ An abstract class from which useful spatial classes are
derived }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("SpatialData", ...)}.
However, avoid this, see below. 
}
\section{Slots}{
  \describe{
    \item{\code{bbox}:}{Object of class \code{"matrix"}; 2-column matrix
	holding the minimum in first and maximum in second column for the
	x-coordinate (first row), y-coordinate (second row) and optionally
	z-coordinate (third row). }
    \item{\code{proj4string}:}{Object of class \code{"CoRS"};
	holding a valid proj4 string, which can be used for unprojecting
	or reprojecting coordinates; it is initialised to NA. Other strings
	are checked for validity in the proj4 library.}
  }
}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "SpatialDataFrame", to = "SpatialData")}: this essentially removes the data and coordinate information from a
	SpatialDataFrame, leaving little useful information on itself. }
  }
}
\references{  }
\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl}}
\note{  }

\section{Warning }{this class is not useful in itself, but all spatial
classes in this package derive from it }

\seealso{
  \code{\link{SpatialDataFrame-class}},
  \code{\link{SpatialDataFrameGrid-class}},
  \code{\link{SpatialDataPolygons-class}}
}
\examples{
}
\keyword{classes}
