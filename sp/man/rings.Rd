\name{polygons}
\alias{polygons}
\alias{polygons<-}

\title{ sets spatial coordinates to create spatial data, or retrieves
spatial coordinates }
\description{ sets spatial coordinates to create spatial data, or retrieves
spatial coordinates }
\usage{
	polygons(obj)
	polygons(object) <- value
}
\arguments{
\item{obj}{ object of class "SpatialPolygonsDataFrame" }
\item{object}{ object of class "data.frame" }
\item{value}{ object of class "SpatialPolygons" }
}
\value{ polygons returns the SpatialPolygons of obj; polygons<- promotes a
data.frame to a SpatialPolygonsDataFrame object }
\examples{
data(ncshp)
nc1 <- as.SpatialPolygons.Shapes(nc.shp$Shapes, as.character(nc.shp$att.data$FIPS))
df <- nc.shp$att.data
rownames(df) <- df$FIPS
polygons(df) <- nc1
class(df)
}
\keyword{manip}
