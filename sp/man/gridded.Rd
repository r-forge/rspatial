\name{gridded}
\alias{gridded}
\alias{gridparameters}
\alias{gridded<-}

\title{Create a SpatialDataFrameGrid from a SpatialDataFrame, or the
reverse }
\description{ Creates a SpatialDataFrameGrid from a SpatialDataFrame,
auto-detecting grid topology, or reverses the operation }
\usage{
gridded(obj) <- value
gridded(obj)
gridparameters(obj)
}
\arguments{
  \item{obj}{ An object of class SpatialDataFrame or SpatialDataFrameGrid }
  \item{value}{ logical; if TRUE a SpatialDataFrame is promoted to a
  SpatialDataFrameGrid if the spatial coordinates are indeed on a
  regular grid. If FALSE, grid topology is removed and a
  SpatialDataFrame is returned }
}
\value{
  in the assignment, an object of class \code{SpatialDataFrameGrid}.
  slots of this S4 class are described in \link{SpatialDataFrameGrid-class}.

  in the form \code{gridded(obj)}, it returns TRUE or FALSE, being
  whether the object is a SpatialDataFrameGrid (TRUE) or not (FALSE).

  \code{gridparameters} returns, if \code{obj} inherits from
  SpatialDataFrameGrid its grid parameters, else it returns numeric(0).
}

\details{ Being on a regular grid means: no complete rows or columns are
missing in the contiguous area occupied. The increments of (x, y and z)
coordinates must have a constant value. }

\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }

\seealso{ \link{SpatialDataFrame-class}, 
\link{SpatialDataFrameGrid-class},
\link{SpatialData-class}, \link{coordinates}}

\examples{
data(meuse.grid)                 # data.frame
coordinates(meuse.grid) <- ~x+y  # promotes meuse to SpatialDataFrame
gridded(meuse.grid) <- TRUE      # promotes meuse to SpatialDataFrameGrid
gridded(meuse.grid)
gridparameters(meuse.grid)
oldpars <- par()
par(mfrow=c(1,2))
image(meuse.grid, "dist", main = "distance to river")
gridded(meuse.grid) <- FALSE     # demotes meuse to SpatialDataFrameGrid
plot(meuse.grid, pch = ".", main = "grid centers")
gridded(meuse.grid)
gridparameters(meuse.grid)
par(oldpars)
}

\keyword{spatial}
