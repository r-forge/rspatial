\name{SpatialGridDataFrame}
\alias{SpatialGridDataFrame}

\title{ define spatial grid with attribute data }
\description{
defines spatial grid by offset, cell size and dimensions
}
\usage{
SpatialGridDataFrame(points = NULL, grid = NULL, data, 
		tolerance = 10 * .Machine$double.eps, 
		coords.nrs = numeric(0), proj4string = CRS(as.character(NA)))
}
\arguments{
	\item{points}{ coordinates, either as matrix or as object of class
		\link{SpatialPoints-class} }
	\item{grid}{ grid topology; object of class \link{GridTopology-class};
	either \code{points} or \code{grid} should be supplied}
	\item{data}{ data.frame; contains the attribute (actual grid) data }
	\item{tolerance}{ precision up to which extent points should be 
	exactly on a grid}
    \item{coords.nrs}{ignore}
    \item{proj4string}{object of class \link{CRS-class}}
}

\value{ SpatialGridDataFrame returns an object of class
\link{SpatialGridDataFrame-class}. 

}

\note{ 
SpatialGrid stores grid topology and may or may not store the coordinates
of the actual points, which may form a subset of the full grid. To find
out or change this, see \link{fullgrid}.
}

\references{ }

\author{ Edzer J. Pebesma }

\seealso{ 
\link{gridded},
\link{"gridded<-"},
\link{SpatialGrid},
\link{SpatialGrid-class}
}

\examples{
data(meuse.grid)
m = SpatialGridDataFrame(points = meuse.grid[c("x", "y")], data = meuse.grid)
class(m)
summary(m)
}

\keyword{spatial}
