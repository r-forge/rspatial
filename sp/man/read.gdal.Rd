\name{read.gdal}
\alias{read.gdal}
\title{ read GDAL supported grid maps through rgdal }
\description{ read GDAL grid maps }
\usage{ 
read.gdal(fname, ..., silent = FALSE)
}

\arguments{
\item{fname}{ file name of grid map }
\item{silent}{ logical; if TRUE, comment is suppressed }
\item{...}{ arguments passed to either \code{getRasterData}, or
\code{getRasterTable}, depending on rotation angles (see below);
see the rgdal documentation for the available options (subsetting
etc.) }
}

\value{
\code{read.gdal} returns the data in the file, read through GDAL and
package rgdal---it requires package rgdal to be installed. 

Usually, GDAL maps will be north-south oriented, in which case the rgdal
function \code{getRasterData} is used to read the data, and an object
of class \link{SpatialGridDataFrame-class} is returned.

Some map formats supported by GDAL are not north-south oriented grids. If
this is the case, \code{read.gdal} returns the data as a set of point
data, being of class \link{SpatialPointsDataFrame-class}. If the points
are on a 45 or 90 degree rotated grid, you can try to enforce gridding
later on by e.g. using \code{\link{gridded}(x)=TRUE}.
}

\seealso{ \link{as.image.SpatialGridDataFrame}, \link{image},
\link{read.asciigrid} }

\author{Edzer J.\ Pebesma, e.pebesma@geog.uu.nl}

\examples{
#x <- read.gdal(system.file("external/test.ag", package="sp")[1])
#class(x)
#image(x)
#summary(x)
#x <- read.gdal(system.file("external/simple.ag", package="sp")[1])
#class(x)
#image(x)
#summary(x)
#y = read.gdal(system.file("pictures/Rlogo.jpg", package = "rgdal")[1])


# library(rgdal)
# logo <- system.file("pictures/Rlogo.jpg", package="rgdal")[1]
# x <- GDAL.open(logo)
# gt = .Call('RGDAL_GetGeoTransform', x, PACKAGE="rgdal")
# data <- getRasterData(x)
# GDAL.close(x)

data(Rlogo)
d = dim(data)
cellsize = abs(c(gt[2],gt[6]))
cells.dim = c(d[1], d[2]) # c(d[2],d[1])
cellcentre.offset = c(x = gt[1] + 0.5 * cellsize[1], y = gt[4] - (d[2] - 0.5) * abs(cellsize[2]))
grid = GridTopology(cellcentre.offset, cellsize, cells.dim)
df = as.vector(data[,,1])
for (band in 2:d[3]) df = cbind(df, as.vector(data[,,band]))
df = as.data.frame(df)
names(df) = paste("band", 1:d[3], sep="")
Rlogo <- SpatialGridDataFrame(grid = grid, data = df)
summary(Rlogo)
gridplot(Rlogo, zcol=1:3, names.attr=c("red","green","blue"), col.regions=grey(0:100/100),
	main="example of three-layer (RGB) raster image", as.table=TRUE)
}
\keyword{programming}
