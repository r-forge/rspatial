\name{gridplot}
\alias{gridplot}
\alias{ringplot}
\title{ plot grids and polygons using levelplot }
\description{ plotting grid and polygon maps with levelplot }
\usage{
gridplot(data, zcol, names.attr, col.regions = bpy.colors(), ...)
ringplot(data, zcol, names.attr, col.regions = bpy.colors(), ...)
}
\arguments{
\item{data}{ object of class (or extending) SpatialGridDataFrame 
(in case of gridplot) of SpatialRingsDataFrame (in case of ringplot) }
\item{zcol}{ z-coordinate column name(s), or a column number (range)
(following spatial coordinate columns: 1 refers to the first
non-coordinate column, etc.); default all attribute columns are used }
\item{names.attr}{names of the set of z-columns (these names
will appear in the plot); if omitted, column names of \code{zcol} }
\item{col.regions}{ color vector to be passed to \link{levelplot}}
\item{...}{lplot passes these through to \link{levelplot}}
}

\value{ \code{gridplot} and \code{ringplot} are wrappers around
\link{levelplot} for spatial data. For gridded data we use levelplot
directly, for polygons data a modified panel function is passed to
levelplot, which calls \link{grid.polygon} from package \link{grid}
for each of the polygons.
}

\seealso{ \link{levelplot} in package \code{lattice}, \link{stack}}
\examples{
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE
gridplot(meuse.grid, as.table=TRUE, scales=list(draw=FALSE), xlab="", ylab="")
}
\keyword{dplot}
