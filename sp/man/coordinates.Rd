\name{coordinates}
\alias{coordinates}
\alias{coordinates<-}

\title{Create a SpatialDataFrame, or extract coordinates }
\description{ Creates a SpatialDataFrame, a data.frame that is aware in
which columns its spatial coordinates are stored, or retrieves
coordinate values }
\usage{
coordinates(obj) <- value
coordinates(sdf)
}
\arguments{
  \item{obj}{ An object of class data.frame, or an object assigned NULL }
  \item{value}{ coordinates: either a character vector with column names
  present in obj, or a formula containing the coordinate columns in the rhs,
  as in \code{~x+y}, or a matrix or data.frame containing the actual
  coordinate values. }
  \item{sdf}{An object of class \code{SpatialDataFrame}, see
  \code{\link{SpatialDataFrame-class}} }
}
\value{
  The first function creates an object of class \code{SpatialDataFrame};
  slots of this S4 class are described in \link{SpatialDataFrame-class}.
  The second function retrieves the coordinates from a SpatialDataFrame
  and returns them as a data.frame
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
data(meuse) # reset
n = nrow(meuse)
coordinates(meuse) <- cbind(runif(n),runif(n)) # add random coordinates
}

\keyword{spatial}
