\name{getpoly}
\alias{getpoly}
\title{
Draw a polygon on the current graphics device
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
% Converted by Sd2Rd version 0.3-3.
