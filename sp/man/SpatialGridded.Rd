\name{SpatialGridded}
\alias{SpatialGridded}
\alias{plot.SpatialGridded}
\alias{coordinatevalues}

\title{ define spatial grid }
\description{
defines spatial grid by offset, cell size and dimensions
}
\usage{
SpatialGridded(cellcentre.offset, cellsize, cells.dim, crs = CRS(as.character(NA)),
    cell.extent = 0.5)
coordinatevalues(obj)
}
\arguments{
    \item{cellcentre.offset}{numeric; vector with the smallest coordinates for
    each dimension}
    \item{cellsize}{numeric; vector with the cell size in each dimension}
    \item{cells.dim}{integer; vector with number of cells in each dimension}
    \item{crs}{Object of class \code{"CRS"}; projection string }
	\item{cell.extent}{numeric; amount with which we should extent the bbox, expressed
	as fraction of cellsize}
	\item{obj}{object of class or deriving from \link{SpatialGridded-class}}
}

\value{ object of class \link{SpatialGridded-class};

\code{coordinatevalues} returns a list with the unique x-coordinates,
y-coordinate, etc. instead of the \link{coordinates} of all grid cells}

\note{ only stores grid topology, retrieving coordinates will calculate
them from topology }

\references{ }

\author{ Edzer J. Pebesma }

\seealso{ 
\link{SpatialGridded-class},
\link{SpatialGriddedDataFrame-class},
\link{SpatialCell-class},
\link{SpatialCellDataFrame-class},
}

\examples{
x = SpatialGridded(c(0,0), c(1,1), c(5,5))
class(x)
x
summary(x)
coordinates(x)
coordinates(SpatialGridded(c(0,0), c(1,1), c(5,5), cell.extent = 0))
coordinatevalues(x)
}

\keyword{spatial}
