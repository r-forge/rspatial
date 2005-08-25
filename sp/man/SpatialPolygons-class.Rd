\name{SpatialPolygons-class}
\docType{class}
\alias{SpatialPolygons-class}
\alias{[,SpatialPolygons-method}
\alias{as.data.frame.SpatialPolygons}
\alias{plotSpatialPolygons}
\alias{plot.SpatialPolygons}

\title{Class "SpatialPolygons"}
\description{  class to hold polygon topology (without attributes) }
\section{Objects from the Class}{
Objects can be created by calls to the function \link{SpatialPolygons}
}
\section{Slots}{
  \describe{
    \item{\code{polygons}:}{Object of class \code{"list"}; list elements are
	all of class \link{Polygons-class}}
    \item{\code{plotOrder}:}{Object of class \code{"integer"}; integer array
	giving the order in which objects should be plotted }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; see \link{Spatial-class} }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; see \link{CRS-class}}
  }
}
\section{Extends}{
Class \code{"Spatial"}, directly.
}
\section{Methods}{
No methods defined with class "SpatialPolygons" in the signature.
}
\references{ }
\author{ Roger Bivand }
\note{ }
\seealso{ \link{SpatialPolygons} }
\examples{
data(ncshp)
nc1 <- as.SpatialPolygons.Shapes(nc.shp$Shapes, as.character(nc.shp$att.data$FIPS))
plotSpatialPolygons(nc1)
invisible(text(getSpPPolygonsLabptSlots(nc1), labels=getSpPPolygonsIDSlots(nc1), cex=0.6))
data(ncmap)
IDs <- sapply(strsplit(ncmap$names, ","), function(x) x[2])
nc2 <- as.SpatialPolygons.map(ncmap, IDs)
plotSpatialPolygons(nc2)
invisible(text(getSpPPolygonsLabptSlots(nc2), labels=getSpPPolygonsIDSlots(nc2), cex=0.6))
data(co37_d90_arc)
data(co37_d90_pal)
data(co37_d90_pat)
IDs <- paste(pat$ST[-1], pat$CO[-1], sep="")
nc3 <- as.SpatialPolygons.pal(arc, pal, IDs=IDs)
plotSpatialPolygons(nc3)
invisible(text(getSpPPolygonsLabptSlots(nc3), labels=getSpPPolygonsIDSlots(nc3), cex=0.6))
}
\keyword{classes}
