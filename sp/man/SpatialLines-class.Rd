\name{SpatialLines-class}
\docType{class}
\alias{SpatialLines-class}
% \alias{coordinates,SpatialLines-method}

\title{Class "SpatialLines" ~~~ }
\description{  ~~ A concise (1-5 lines) description of what the class is.  ~~}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("SpatialLines", ...)}.
    ~~ describe objects here ~~ 
}
\section{Slots}{
  \describe{
    \item{\code{lines}:}{Object of class \code{"list"}; list members are all of
	class \link{Slines-class}}
    \item{\code{bbox}:}{Object of class \code{"matrix"}; see \link{Spatial-class} }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; see \link{CRS-class}}
  }
}
\section{Extends}{
Class \code{"Spatial"}, directly.
}
\section{Methods}{
  \describe{
    \item{coordinates}{\code{signature(obj = "SpatialLines")}: retrieve
	coordinates; value is a list of lists with matrices }
	\item{plot}{\code{\signature(x = "SpatialLines")}: 
	plot lines in SpatialLines object}
	\item{lines}{\code{\signature(x = "SpatialLines")}: 
	add lines in SpatialLines object to a plot }
  }
}
\references{ }
\author{ Roger Bivand, Edzer Pebesma }
\note{ }

\seealso{
	\link{Sline-class}, \link{Slines-class}
}
\examples{
}
\keyword{classes}
