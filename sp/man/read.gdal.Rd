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
x <- read.gdal(system.file("external/test.ag", package="sp")[1])
class(x)
image(x)
summary(x)
x <- read.gdal(system.file("external/simple.ag", package="sp")[1])
class(x)
image(x)
summary(x)
y = read.gdal(system.file("pictures/Rlogo.jpg", package = "rgdal")[1])
summary(y)
gridplot(y, zcol=1:3, names.attr=c("red","green","blue"), col.regions=grey(0:100/100),
	main="example of three-layer (RGB) raster image", as.table=TRUE)
}
\keyword{programming}
