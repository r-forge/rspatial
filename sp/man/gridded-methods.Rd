\name{gridded-methods}
\docType{methods}
\alias{gridded-methods}
\alias{gridded,Spatial-method}
\alias{"gridded<-"}
\alias{gridded}
\title{ specify spatial data as being gridded, or find out whether they are }
\description{
returns logical (TRUE or FALSE) telling whether the object is gridded
or not; in assignment promotes a non-gridded structure to a gridded
one, or demotes a gridded structure back to a non-structured one.
}
\usage{
	gridded(obj)
	gridded(obj) <- TRUE
}
\arguments{
\item{obj}{ object deriviving from class "Spatial" }
}
\section{Methods}{
\describe{

\item{obj = "Spatial"}{ object deriviving from class "Spatial" }
}}
\value{ if object derives from class Spatial, gridded(object) will tell
whether it is has topology on a regular grid; if assigned TRUE, if the
object derives from SpatialPoints and has gridded topology,
grid topology will be added to object, and the class of the object
will be promoted to \link{SpatialCell-class} or 
\link{SpatialCellDataFrame-class}
}
\keyword{methods}
\examples{
# just 9 points on a grid:
x <- c(1,1,1,2,2,2,3,3,3)
y <- c(1,2,3,1,2,3,1,2,3)
xy <- cbind(x,y)
S <- SpatialPoints(xy)
class(S)
plot(S)
gridded(S) <- TRUE
gridded(S)
class(S)
summary(S)
plot(S)
gridded(S) <- FALSE
gridded(S)
class(S)

# data.frame
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE
plot(meuse.grid) # not much good
summary(meuse.grid)

}
\keyword{ }
