\name{delpoints}
\alias{delpoints}
\title{
Point Operations
}
\description{
Select points to delete from a points data set.
}
\usage{
delpoints(pts,add=F,\dots)
}
\arguments{
\item{pts}{
a points data set
}
\item{add}{
if false, plot the points using \code{pointmap}.
}}
\section{METHOD}{
Using the mouse, the user selects points on the current graphics device.
These points are marked on the plot as they are selected. The function
returns the remaining points as a points object.
}
\value{
A points object containing the undeleted points.


}
\section{Side Effects}{
If \code{add} is false the points are plotted on the current plot device.
}
% Converted by Sd2Rd version 0.3-3.
