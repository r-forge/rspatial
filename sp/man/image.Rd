\name{image.SpatialCellDataFrame}
\alias{image.SpatialCellDataFrame}
\alias{as.image.SpatialCellDataFrame}
\title{
image gridded data in SpatialCellDataFrame to image format
}
\description{
Convert gridded data in SpatialDataFrameGrid to image format;
call image on data in SpatialDataFrameGrid format
}
\usage{
image.SpatialCellDataFrame(x, attr = 1, xcol = 1, ycol = 2, asp = 1, ...)
as.image.SpatialCellDataFrame(data, attr = 1, xcol = 1, ycol = 2)
}
\arguments{
\item{x}{ object of class \code{SpatialCellDataFrame}}
\item{data}{ object of class \code{SpatialCellDataFrame}}
\item{attr}{ column number of attribute variable; this may be
the column name in the data.frame of \code{data} (as.data.frame(data)), or
a column number, counted when ignoring the coordinates in
the data.frame part of data; e.g. attr = 1 will return the
third column if coordinates are in colunns 1 and 2. 
If no attribute is present, zeros are returned }
\item{xcol}{ column number of x-coordinate, in the coordinate matrix }
\item{ycol}{ column number of y-coordinate, in the coordinate matrix }
\item{asp}{ aspect ratio of unit x and unit y axis }
\item{...}{ arguments passed to \link{image}, see examples }
}
\value{ \code{as.image.SDFG} returns a list with elements \code{x} and
\code{y}, containing the coordinates of the cell centres of a matrix
\code{z}, containing the attribute values; see links below. }

\note{ Providing \code{xcol} and \code{ycol} attributes seems obsolete,
and it is for 2D data, but it may provide opportunities for plotting
certain slices in 3D data. I haven't given this much thought yet. It
may get thrown out when Barry sees this.

\link{filled.contour} seems to misinterpret the coordinate values,
if we take the image.default manual page as the reference. }

\references{ }

\author{ Edzer J. Pebesma }

\seealso{ \link{image.default}, \link{SpatialCellDataFrame-class},
\link{levelplot} in package \code{lattice} }

\examples{
data(meuse.grid)
coordinates(meuse.grid) = c("x", "y") # promote to SpatiatDataFrame
gridded(meuse.grid) = TRUE            # promote to SpatialDataFrameGrid
image(meuse.grid, "dist", asp = 1, main = "Distance to river Meuse")
data(meuse)
coordinates(meuse) = c("x", "y")
points(coordinates(meuse), pch = "+")
}

\keyword{spatial}
