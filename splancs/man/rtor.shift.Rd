\name{rtor.shift}
\alias{rtor.shift}
\title{
Point Operations
}
\description{
Perform a random toroidal shift on a point data set
}
\usage{
rtor.shift(pts,rect)
}
\arguments{
\item{pts}{
The point data set to shift
}
\item{rect}{
A rectangle defining the region for the toroidal map. If not given, 
the bounding box of \fCpts} is used.
}}
\value{
A point data set like \fCpts}, but after application of a random toroidal 
shift along the x and y axes. 
}
\section{METHOD}{
The planar region defined by \fCrect}
is assumed connected at its top and bottom edges, and at its left and
right sides. A random shift is applied to the 
points and the resulting set of points returned. 


}
\seealso{
\fCtor.shift}
}
% Converted by Sd2Rd version 0.3-3.
