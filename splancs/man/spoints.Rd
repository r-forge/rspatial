\name{spoints}
\alias{spoints}
\title{
Point Objects
}
\description{
Creates and tests for data in spatial point format.
}
\usage{
spoints(data,npoints=length(data)/2)
}
\arguments{
\item{data}{
vector containing the data values for the points
in order (x1,y1),(x2,y2),\dots{}


}
\item{npoints}{
number of points to generate.
}}
\value{
\code{spoints} returns an object suitable for use as a point data
object. If \code{npoints} is given, the vector data is either truncated
or repeated until sufficient data values are generated.
The returned object is a two-column matrix, where the first column stores the 
x-coordinate, and the second column stores the y-coordinate.


}
\seealso{
\code{npts}
}
% Converted by Sd2Rd version 0.3-3.
