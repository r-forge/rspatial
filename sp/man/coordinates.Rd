\name{coordinates-methods}
%\name{coordinates}
\docType{methods}
\alias{coordinates-methods}
\alias{coordinates,Spatial-method}
\alias{"coordinates<-"}
\alias{coordinates}
\alias{coordinates.SPDF}

\title{ sets spatial coordinates to create spatial data, or retrieves
spatial coordinates }
\description{ sets spatial coordinates to create spatial data, or retrieves
spatial coordinates }
\usage{
	coordinates(object) <- value
	coordinates(obj)
}
\arguments{
\item{obj}{ object deriving from class "Spatial" }
\item{object}{ object of class "data.frame" }
\item{value}{ spatial coordinates; either a matrix, list, or data
frame with numeric data, or column names, column number or a
reference: a formula (in the form of e.g. \code{~x+y}), column numbers
(e.g. \code{c(1,2)}) or column names (e.g. \code{c("x","y")}) specifying
which columns in \code{object} are the spatial coordinates. If the coordinates
are part of object, giving the reference does not duplicate them, giving
their value does duplicate them in the resulting structure.
}
}
\section{Methods}{
\describe{
\item{\code{signature(obj = "Spatial")}}{object deriving from class "Spatial" }
\item{\code{signature(obj = "list")}}{tries to retrieve coordinates from a list, having
e.g. x and y components (numeric vectors with coord in each dimension) }
\item{\code{signature(obj = "data.frame")}}{retrieve coordinates from data.frame }
\item{\code{signature(obj = "matrix")}}{does nothing }
}}
\value{ an object of class SpatialPointsDataFrame }
\keyword{methods}
\examples{
# data.frame
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE
bbox(meuse.grid)

}
\keyword{ }
