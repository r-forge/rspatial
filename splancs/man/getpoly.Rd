\name{getpoly}
\alias{getpoly}
\title{
Polygon Operations
}
\description{
Draw a polygon on the current graphics device
}
\usage{
getpoly(quiet=F)
}
\arguments{
\item{quiet}{
if true, don't prompt for input of a polygon.
}}
\section{METHOD}{
The system prompts the user to enter points on the current graphics
device using the mouse or other pointing device. The points are joined
on the screen with the current line symbol.
}
\value{
A polygon data set consisting of the points entered. The current coordinate 
system is used.


}
\section{Side Effects}{
A polygon of the points entered is drawn on the current graphics device.
}
\examples{
pointmap(case1)                      #display some data
cat ("Select region of interest \\n") #prompt the user
newpoly <- getpoly()                 # define a polygon
}
% Converted by Sd2Rd version 0.3-3.
