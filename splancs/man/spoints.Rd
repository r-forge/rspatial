\name{is.points}
\alias{is.points}
\alias{as.points}
\alias{spoints}
\title{
Point Objects
}
\description{
Creates and tests for data in spatial point format.
}
\usage{
is.points(p)
as.points(p)
spoints(data,npoints=length(data)/2)
}
\arguments{
\item{data}{
vector containing the data values for the points
in order (x1,y1),(x2,y2),\dots{}


}
\item{p}{
any S-PLUS object(s).
}
\item{npoints}{
number of points to generate.
}}
\value{
\fCspoints} returns an object suitable for use as a point data
object. If \fCnpoints} is given, the vector data is either truncated
or repeated until sufficient data values are generated.
The returned object is a two-column matrix, where the first column stores the 
x-coordinate, and the second column stores the y-coordinate.


\fCis.points} returns TRUE if \fCp} is a points object, FALSE otherwise.


\fCas.points} tries to return \fCp} as a points object. Valid options for 
\fCp} are:
\(bu a points object ; returns it unaltered.
\(bu a list with x and y elements of the same length ; returns a
points object with the x and y elements as the coordinates of the points.
\(bu two vectors of equal length ; returns a points object with the 
first vector as the x coordinates, the second vector as the y-coordinates.
}
\seealso{
\fCnpts}
}
\examples{
mypoints <- spoints(scan("xydata"))
          # creates a points object from a data file.


}
% Converted by Sd2Rd version 0.3-3.
\name{is.points}
\alias{is.points}
\alias{as.points}
\alias{spoints}
\alias{spoints}
}
\title{
See \fCis.points}
