\name{stack}
\alias{lplot}
\alias{map.to.lev}
\alias{stack.SpatialPointsDataFrame}
\alias{stack.SpatialCellDataFrame}
\title{ rearrange data in SpatialPointsDataFrame or SpatialCellDataFrame 
for plotting with levelplot }
\description{ plotting grid and polygon maps with levelplot;
rearrange SpatialDataFrame for plotting with levelplot }
\usage{
lplot(data, zcol, names.attr, col.regions = bpy.colors(), expand = 0.03, ...)
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
\item{expand}{numeric; factor to expand the bounding box with when plotting
concerns SpatialDataFramePolygons }
\item{n}{ number of columns to be plotted }
\item{df}{ logical; if TRUE, return data.frame, else return SpatialDataFrame }
\item{x}{ see \code{data}}
\item{select}{ see \code{zcol}}
\item{...}{lplot passes these through to \link{levelplot}, otherwise ignored}
}

\value{ \code{lplot} is a wrapper around \link{levelplot} for spatial
data. Gridded data uses levelplot directly, for polygons data a modified
panel function is passed to levelplot, which calls \link{grid.polygon}
for each of the polygons.

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
require(lattice)
data(meuse.grid) # data frame
meuse.grid$idist = 1 - meuse.grid$dist
coordinates(meuse.grid) = c("x", "y") # promotes to SpatialDataFrame
levelplot(z~x+y|name, map.to.lev(meuse.grid, z=c("dist","idist"), names.attr =
	c("distance", "inverse of distance")), aspect = "iso")
levelplot(values~x+y|ind, as.data.frame(stack(meuse.grid)),aspect = "iso")
gridded(meuse.grid) = TRUE
levelplot(z~x+y|name, map.to.lev(meuse.grid, z=c("dist","idist"), names.attr =
	c("distance", "inverse of distance")), aspect = "iso")
levelplot(values~x+y|ind, as.data.frame(stack(meuse.grid)), asp = "iso")

}
\keyword{dplot}
