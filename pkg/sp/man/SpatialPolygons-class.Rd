\name{SpatialPolygons-class}
\docType{class}
\alias{SpatialPolygons-class}
\alias{[,SpatialPolygons-method}
\alias{as.data.frame.SpatialPolygons}
\alias{plot,SpatialPolygons,missing-method}
\alias{summary,SpatialPolygons-method}
\alias{rbind.SpatialPolygons}
\alias{coerce,Polygons,Lines-method}
\alias{coerce,SpatialPolygons,SpatialLines-method}
\alias{row.names.SpatialPolygons}


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
Methods defined with class "SpatialPolygons" in the signature:
  \describe{
    \item{[}{\code{signature(obj = "SpatialPolygons")}: select subset of (sets of) polygons; NAs are not permitted in the row index}
	\item{plot}{\code{signature(x = "SpatialPolygons", y = "missing")}: 
	plot polygons in SpatialPolygons object}
	\item{summary}{\code{signature(object = "SpatialPolygons")}: summarize object}
	\item{rbind}{\code{signature(object = "SpatialPolygons")}: rbind-like method}
  }
}
\note{
\code{rbind} calls the function \code{\link{SpatialPolygons}}, where it is 
checked that all IDs are unique. If \code{rbind}-ing \code{SpatialPolygons} without 
unique IDs, it is possible to set the argument \code{makeUniqueIDs = TRUE}, although
it is preferred to change these explicitly with \code{\link{spChFIDs}}.
}
\author{ Roger Bivand }
\seealso{ \link{SpatialPolygons} }
\examples{
%data(ncshp)
%nc1 <- as.SpatialPolygons.Shapes(nc.shp$Shapes, as.character(nc.shp$att.data$FIPS))
%plot(nc1)
%invisible(text(coordinates(nc1), labels=sapply(slot(nc1, "polygons"), function(i) slot(i, "ID")), cex=0.6))
%data(ncmap)
%IDs <- sapply(strsplit(ncmap$names, ","), function(x) x[2])
%nc2 <- as.SpatialPolygons.map(ncmap, IDs)
%plot(nc2)
%invisible(text(coordinates(nc2), labels=sapply(slot(nc2, "polygons"), function(i) slot(i, "ID")), cex=0.6))
%data(co37_d90_arc)
%data(co37_d90_pal)
%data(co37_d90_pat)
%IDs <- paste(pat$ST[-1], pat$CO[-1], sep="")
%nc3 <- as.SpatialPolygons.pal(arc, pal, IDs=IDs)
%plot(nc3)
%invisible(text(coordinates(nc3), labels=sapply(slot(nc3, "polygons"), function(i) slot(i, "ID")), cex=0.6))
grd <- GridTopology(c(1,1), c(1,1), c(10,10))
polys <- as.SpatialPolygons.GridTopology(grd)
plot(polys)
#text(coordinates(polys), labels=sapply(slot(polys, "polygons"), function(i) slot(i, "ID")), cex=0.6)
text(coordinates(polys), labels=row.names(polys))
}
\keyword{classes}