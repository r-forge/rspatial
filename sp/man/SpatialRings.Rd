\name{SpatialRings}
\alias{SpatialRings}
\alias{SpatialRingsDataFrame}
\title{ create objects of class SpatialRings or SpatialRingsDataFrame}
\description{ create objects of class \code{SpatialRings} or \code{SpatialRingsDataFrame} from
lists of \code{Srings} objects and \code{data.frame}s}
\usage{ 
SpatialRings(Srl, pO)
SpatialRingsDataFrame(Sr, data, labelPoints)

}
\arguments{
\item{Srl}{ list with objects of class \link{Srings-class}}
\item{pO}{ integer vector; plotting order }
\item{Sr}{ object of class \link{SpatialRings-class}}
\item{data}{ object of class \code{data.frame}; the number of rows in \code{data} should
equal the number of \link{Srings-class} objects in \code{Sr}}
\item{labelPoints}{ RSB!! }
}
\value{
\code{SpatialRings} returns object of class \code{SpatialRings};
\code{SpatialRingsDataFrame} returns object of class \code{SpatialRingsDataFrame}
}
\seealso{ \link{SpatialRings-class}, \link{SpatialRingsDataFrame-class} }

\keyword{manip}
