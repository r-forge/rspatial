\name{pointmap}
\alias{pointmap}
\alias{polymap}
\title{
Graphics
}
\description{
Plots point and polygon data sets on the current graphics device.
}
\usage{
pointmap(pts,add=F,axes=T,xlab="",ylab="",\dots)
polymap(poly,add=F,axes=T,xlab="",ylab="",\dots)
}
\arguments{
\item{pts}{
a points data set.
}
\item{add}{
if false, start a new plot. If true, superimpose on current plot.
}
\item{axes}{
if true, display axes with labelling. If false, do not display any 
axes on the plot.
}
\item{xlab,ylab}{
Label strings for x and y axes.
}
\item{...}{
Graphical arguments may be entered, and these are passed to the
standard S \fCpoints} and \fCpolygon} routines.


}}
\section{Side Effects}{
The specified data set is plotted on the current graphics device, either
as points or polygons. For \fCpolymap}, the last point in the data set
is drawn connected to the first point.
}
\section{NOTES}{
When starting a new plot, \fCpointmap} and \fCpolymap} set the axes to preserve
the aspect ratio in the data, and the graphics parameter \fCpty} is set
to \fC"s"} to produce square plots.
Graphical parameters can also be supplied to these routines, and are passed 
through to \fCplot}. Some useful parameters include \fCpch} to change the plotting
character for points, \fClty} to change the line type for polygons, and 
\fCtype="n"} to set up axes for the plot without plotting anything.
}
\seealso{
\fCpar} (standard S function), \fCmpoint}
}
\examples{
data(bodmin)
require(MASS)
eqscplot(bodmin$poly, type="n")
pointmap(as.points(bodmin), add=T)
polymap(bodmin$poly, add=T)
}
% Converted by Sd2Rd version 0.3-3.
