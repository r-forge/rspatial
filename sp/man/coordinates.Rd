\name{coordinates}
\alias{coordinates}
\alias{coordinates<-}
\alias{bbox}

\title{Create a SpatialDataFrame, or extract coordinates }
\description{ Creates a SpatialDataFrame, a data.frame that is aware in
which columns its spatial coordinates are stored, or retrieves
coordinate values }
\usage{
coordinates(obj) <- value
coordinates(sdf, what = c("values", "names", "columns"))
bbox(sd)
}
\arguments{
  \item{obj}{ An object of class data.frame, or an object assigned NULL }
  \item{value}{ coordinates: either a character vector with column names
  present in obj, or a formula containing the coordinate columns in the rhs,
  as in \code{~x+y}, or a matrix or data.frame containing the actual
  coordinate values. }
  \item{sdf}{An object of class \code{SpatialDataFrame}, see
  \code{\link{SpatialDataFrame-class}} }
  \item{what}{switch that can be set to retrieve coordinate column names
  or numbers instead of their actual values}
  \item{sd}{An object of class, or inheriting from, \code{SpatialData}, see
  \code{\link{SpatialData-class}}}
}
\value{
  The first function creates an object of class \code{SpatialDataFrame};
  slots of this S4 class are described in \link{SpatialDataFrame-class}.
  The second function retrieves the coordinates, or their names or column
  numbers, from a SpatialDataFrame; coordinate values are returned as
  a data.frame

  bbox returns a matrix with the bounding box (min/max of x and y)
  of the coordinates
}

\details{ }

\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }

\seealso{ \link{SpatialDataFrame-class}, 
\link{SpatialDataFrameGrid-class},
\link{SpatialData-class} }

\examples{
data(meuse) # data.frame
coordinates(meuse) <- c("x", "y") # promotes meuse to SpatialDataFrame
data(meuse) # reset to data.frame
coordinates(meuse) <- ~x+y # promotes meuse to SpatialDataFrame
plot(meuse)
bbox(meuse)
data(meuse) # reset
n = nrow(meuse)
coordinates(meuse) <- cbind(runif(n),runif(n)) # add random coordinates
}

\keyword{spatial}
