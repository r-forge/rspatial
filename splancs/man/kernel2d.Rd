\name{kernel2d}
\alias{kernel2d}
\title{
Point Operations
}
\description{
Perform kernel smoothing of a point pattern
}
\usage{
kernel2d(pts,poly,h0,nx=20,ny=20,kernel='quartic')
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon data set
}
\item{h0}{
The kernel width parameter
}
\item{nx}{
Number of points along the x-axis of the returned grid.
}
\item{ny}{
Number of points along the y-axis of the returned grid.
}
\item{kernel}{
Type of kernel function to use. Currently only the quartic kernel is implemented.
}}
\value{
A list with the following components:
\(bu \fC$x} List of x-coordinates at which the kernel function has been evaluated.
\(bu \fC$y} List of y-coordinates at which the kernel function has been evaluated.
\(bu \fC$z} A matrix of dimension \fCnx} by \fCny} containing the value of
the kernel function.
\(bu \fC$h0},\fC$kernel}, containing the values input to \fCkernel2d}




}
\section{METHOD}{
The kernel estimate, with a correction for edge effects, is computed for
a grid of points that span the
input polygon. The kernel function for points in the grid that are outside the polygon are returned
as NA's.
The output list is in a format that can be read into \fCimage()} directly,
for display and superposition onto other plots.
}
\references{
Berman M. and Diggle P.J. (1989) Estimating Weighted Integrals of the
Second-Order Intensity of Spatial Point Patterns.
\emph{J. R. Statist Soc} B51 81-92
}
% Converted by Sd2Rd version 0.3-3.
