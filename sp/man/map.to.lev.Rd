\name{map.to.lev}
\alias{map.to.lev}
\alias{lplot}
\alias{stack.SpatialDataFrame}
\alias{stack.SpatialDataFrameGrid}
\title{ rearrange SpatialDataFrame for plotting with levelplot }
\description{ rearrange SpatialDataFrame for plotting with levelplot }
\usage{
lplot(data, zcol, names.attr, col.regions = bpy.colors(), ...)
map.to.lev(data, zcol = 1:n, n = 2, names.attr, df = TRUE)
stack.SpatialDataFrame(x, select, ...)
}
\arguments{
\item{data}{ object of class (or extending) SpatialDataFrame }
\item{zcol}{ z-coordinate column name(s), or a column number (range) (after
removing the spatial coordinate columns: 1 refers to the first non-coordinate
column, etc. ) }
\item{names.attr}{names of the set of z-columns (these names
will appear in the plot); if omitted, column names of \code{zcol} }
\item{col.regions}{ color vector to be passed to \link{levelplot}}
\item{n}{ number of columns to be plotted }
\item{df}{ logical; if TRUE, return data.frame, else return SpatialDataFrame }
\item{x}{ see \code{data}}
\item{select}{ see \code{zcol}}
\item{...}{lplot passes these through to \link{levelplot}, otherwise ignored}
}

\value{ \code{lplot} is a wrapper around levelplot for spatial, gridded data.

\code{map.to.lev} returns a
data frame with the following elements:
\item{x}{ x-coordinate for each row}
\item{y}{ y-coordinate for each row} 
\item{z}{ column vector with each of the elements in columns \code{zcol}
of \code{data} stacked } 
\item{name}{ factor; name of each of the stacked \code{z} columns } 

\code{stack} is an S3 method: it return a SpatialDataFrame or
SpatialDataFrameGrid with a column \code{values} that has the stacked
coordinates and attributes, and a column \code{ind} that indicates the 
variable stacked.  }
\seealso{ \link{levelplot} in package \code{lattice}, \link{stack}}
\examples{
require(grid)
require(lattice)
data(meuse.grid) # data frame
meuse.grid$idist = 1 - meuse.grid$dist
coordinates(meuse.grid) = c("x", "y") # promotes to SpatialDataFrame
asp = mapasp(meuse.grid)
levelplot(z~x+y|name, map.to.lev(meuse.grid, z=c(3,4), names.attr =
	c("distance", "inverse of distance")), aspect = asp)
levelplot(values~x+y|ind,data.frame(stack(meuse.grid)),aspect = asp)
gridded(meuse.grid) = TRUE
levelplot(z~x+y|name, map.to.lev(meuse.grid, z=c(3,4), names.attr =
	c("distance", "inverse of distance")), aspect = asp)
levelplot(values~x+y|ind,data.frame(stack(meuse.grid)), asp = asp)


}
\keyword{dplot}
