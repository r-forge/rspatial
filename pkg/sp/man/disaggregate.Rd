\name{disaggregate-methods}
\docType{methods}
\alias{disaggregate}
\alias{disaggregate-methods}
\alias{disaggregate,SpatialPolygons-method}
\alias{disaggregate,SpatialLines-method}
\title{ disaggregate SpatialLines or SpatialPolygons }
\description{ disaggregate SpatialLines or SpatialPolygons }
\usage{
disaggregate(x, ...)
}
\arguments{
\item{x}{object of class \link{SpatialLines} or \link{SpatialPolygons}}
\item{...}{ignored}
}
\value{ 
object of class \link{SpatialLines} or \link{SpatialPolygons},
with one \link{Line} per \link{Lines}, or one \link{Polygon}
per \link{Polygons}.
}

\author{ Robert Hijmans }

\keyword{methods}
