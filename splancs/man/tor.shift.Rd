\name{tor.shift}
\alias{tor.shift}
\title{
Point Operations
}
\description{
Perform a toroidal shift on a point data set
}
\usage{
tor.shift(pts,xsh=0.0,ysh=0.0,rect)
}
\arguments{
\item{pts}{
The point data set to shift
}
\item{xsh}{
Amount to shift along the x-axis
}
\item{ysh}{
Amount to shift along the y-axis
}
\item{rect}{
A rectangle defining the region for the toroidal map. If not given, 
the bounding box of \code{pts} is used.
}}
\value{
A point data set like \code{pts}, but after application of a toroidal 
shift along the x and y axes. 
}
\section{METHOD}{
The planar region defined by \code{rect}
is assumed connected at its top and bottom edges, and at its left and
right sides. A shift of \code{xsh} and \code{ysh} is applied to the 
points and the resulting set of points returned. 


}
\seealso{
\code{shift}
}
% Converted by Sd2Rd version 0.3-3.
