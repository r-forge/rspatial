\name{SpatialDataFramePolygons-class}
\docType{class}
\alias{SpatialDataFramePolygons-class}
\alias{plot.SpatialDataFramePolygons}
\alias{SpatialDataFramePolygons}
\alias{summary.SpatialDataFramePolygons}

\title{Class "SpatialDataFramePolygons"}
\description{}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{SpatialDataFramePolygons}, but are usually made by assigning a Polylist4 object to a SpatialDataFrame object using \code{Polygon<-} or \code{SpatialDataFramePolygons}.
   
}
\section{Slots}{
  \describe{
    \item{\code{polygons}:}{Object of class \code{"Polylist4"}}
    \item{\code{has.holes}:}{Object of class \code{"logical"}}
    \item{\code{data}:}{Object of class \code{"data.frame"}}
    \item{\code{coord.names}:}{Object of class \code{"character"}}
    \item{\code{coord.columns}:}{Object of class \code{"integer"}}
    \item{\code{bbox}:}{Object of class \code{"matrix"}}
    \item{\code{proj4string}:}{Object of class \code{"CRS"}}
  }
}
\section{Extends}{
Class \code{"SpatialDataFrame"}, directly.
}
\usage{
SpatialDataFramePolygons(SDF, polygons)
plot.SpatialDataFramePolygons(x, attr = NULL, breaks = NULL, col = NA, asp = 1, xlab = x@coord.names[1], ylab = x@coord.names[2], add = FALSE, xlim = NULL, ylim = NULL, border = par("fg"), xpd = NULL, density = NULL, angle = 45, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SDF}{Object of class \code{"SpatialDataFrame"}}
  \item{polygons}{Object of class \code{"Polylist4"}}
  \item{x}{Object of class \code{"SpatialDataFramePolygons"}}
  \item{attr}{column number of attribute variable; this may be
the column name in the data.frame of \code{data} (data@data), or
a column number, counted when ignoring the coordinates in
the data.frame (data@data); e.g. attr = 1 will return the
third column if coordinates are in colunns 1 and 2. 
If no attribute is present, zeros are returned}
  \item{breaks}{numeric, sorted (weakly) increasingly, of length 'N', say; for use see \code{\link{findInterval}}}
  \item{col}{colours to use for filling the polygons}
  \item{asp}{aspect ratio of unit x and unit y axis}
  \item{xlab, ylab}{label for the x or y axis}
  \item{add}{add to existing plot}
  \item{xlim, ylim}{the x or y limits (min,max) of the plot}
  \item{border}{the color to draw the border}
  \item{xpd}{(where) should clipping take place?}
  \item{density}{the density of shading lines, in lines per inch}
  \item{angle}{the slope of shading lines, given as an angle in degrees (counter-clockwise)}
  \item{\dots}{other arguments passed to plot to set the plot window - not passed to polygon}
}

\value{
\code{SpatialDataFramePolygons} returns an object of class \code{"SpatialDataFramePolygons"}
}

\author{Roger Bivand \email{Roger.Bivand@nhh.no}}
\note{ holes are not detected or handled yet }

\seealso{\code{\link{SpatialDataFrame-class}}}
\examples{
data(ncMap)
P4x <- Map2Poly4(nc.Map, region.id=nc.Map$att.data$FIPSNO)
x <- nc.Map$att.data
class(x)
coordinates(x) <- c("x", "y")
class(x)
Polygons(x) <- P4x
class(x)
summary(x)
plot(x)
points(coordinates(x), pch=8)
plot(x, attr="BIR74", breaks=quantile(x@data$BIR74), col=grey((5:2)/6))
plot(x, attr="BIR74", breaks=quantile(x@data$BIR74), col=grey((5:2)/6),
 border="transparent")
plot(x, attr="BIR74", breaks=quantile(x@data$BIR74), density=c(10,15,20,25),
 angle=c(45,90,135,180))
f.x <- cut(x@data$x, breaks=c(-90, -80, -70))
xx <- cbindSDFP(x, data.frame(f.x))
plot(xx, "f.x", col=c("red", "blue"))
plot(xx, "f.x", density=c(15,15), angle=c(45,135))
}
\keyword{classes}
\keyword{spatial}
