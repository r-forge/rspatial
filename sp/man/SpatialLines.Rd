\name{SpatialLines}
\alias{SpatialLines}
\alias{SpatialLinesDataFrame}
\title{ create objects of class SpatialLines or SpatialLinesDataFrame}
\description{ create objects of class \code{SpatialLines} or \code{SpatialLinesDataFrame} from
lists of \code{Slines} objects and data.frame's}
\usage{ 
SpatialLines(SlineList)
SpatialLinesDataFrame(sl, data)
}
\arguments{
\item{SlineList}{ list with objects of class \link{Slines-class}}
\item{sl}{ object of class \link{SpatialLines-class}}
\item{data}{ object of class \code{data.frame}; the number of rows in \code{data} should
equal the number of elements in \code{sl}}
}
\value{
\code{SpatialLines} returns object of class \code{SpatialLines};
\code{SpatialLinesDataFrame} returns object of class \code{SpatialLinesDataFrame}
}
\seealso{ \link{SpatialLines-class} }

\keyword{manip}
