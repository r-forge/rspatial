\name{SpatialGrid}
\alias{GridTopology}
\alias{SpatialGrid}
\alias{plot.SpatialGrid}
\alias{coordinatevalues}
\alias{points2grid}
\alias{getGridIndex}
\alias{getGridTopology}

\title{ define spatial grid }
\description{
defines spatial grid by offset, cell size and dimensions
}
\usage{
GridTopology(cellcentre.offset, cellsize, cells.dim, crs = CRS(as.character(NA)),
    cell.extent = 0.5)
SpatialGrid(points = NULL, grid = NULL, tolerance = 10 * .Machine$double.eps,
	proj4string = CRS(as.character(NA)))
coordinatevalues(obj)
points2grid(points, tolerance)
getGridIndex(cc, grid)
getGridTopology(obj)
}
\arguments{
    \item{cellcentre.offset}{numeric; vector with the smallest coordinates for
    each dimension}
    \item{cellsize}{numeric; vector with the cell size in each dimension}
    \item{cells.dim}{integer; vector with number of cells in each dimension}
    \item{crs}{Object of class \code{"CRS"}; projection string }
	\item{cell.extent}{numeric; amount with which we should extent the bbox, expressed
	as fraction of cellsize}
	\item{points}{ coordinates, either as matrix or as object of class
	\link{SpatialPoints-class} }
	\item{grid}{ grid topology; object of class \link{GridTopology-class}}
	\item{tolerance}{ precision, used to which extent points are exactly on
	a grid}
	\item{proj4string}{ object of class \link{CRS-class}}
	\item{obj}{object of class or deriving from \link{SpatialGrid-class}}
	\item{cc}{ numeric matrix with coordinates }
}

\value{ GridTopology returns a value of class \link{GridTopology-class};
SpatialGrid returns an object of class \link{SpatialGrid-class}

\code{coordinatevalues} returns a list with the unique x-coordinates,
the unique y-coordinate, etc. instead of the \link{coordinates} of all
grid cells

SpatialGrid returns an object of class \link{SpatialGrid-class}. 

points2grid returns the \link{GridTopology-class} from a set of points.

getGridIndex finds the index of a set of point coordinates in a given
grid topology.

getGridTopology returns the slot of class \link{GridTopology-class} from
obj.
}

\note{ 
SpatialGrid stores grid topology and may or may not store the coordinates
of the actual points, which may form a subset of the full grid. To find
out or change this, see \link{fullgrid}.
}

\references{ }

\author{ Edzer J. Pebesma }

\seealso{ 
\link{SpatialGrid-class},
\link{SpatialGridDataFrame-class},
}

\examples{
x = GridTopology(c(0,0), c(1,1), c(5,4))
class(x)
x
summary(x)
coordinates(x)
coordinates(GridTopology(c(0,0), c(1,1), c(5,4), cell.extent = 0))
coordinatevalues(x)
}

\keyword{spatial}
