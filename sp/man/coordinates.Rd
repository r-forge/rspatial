\name{coordinates-methods}
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
	coordinates(obj)
	coordinates(object) <- value
}
\arguments{
\item{obj}{ object deriving from class "Spatial" }
\item{object}{ object of class "data.frame" }
\item{value}{ spatial coordinates; either a matrix, list, or data
frame with numeric data, or column names, column number or a
formula (in the form of \code{~x+y}) specifying which columns
in \code{object} are the spatial coordinates.
}
}
\section{Methods}{
\describe{
\item{\code{signature(obj = "Spatial")}}{object deriviving from class "Spatial" }
\item{\code{signatture(obj = "list")}}{tries to retrieve coordinates from a list, having
e.g. x and y components (numeric vectors with coord in each dimension) }
\item{\code{signatture(obj = "data.frame")}}{retrieve coordinates from data.frame }
\item{\code{signatture(obj = "matrix")}}{does nothing }
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
