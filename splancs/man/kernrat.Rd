\name{kernrat}
\alias{kernrat}
\title{
Point Operations
}
\description{
Return the ratio of two kernel smoothings
}
\usage{
kernrat(pts1,pts2,poly,h1,h2,nx=20,ny=20,kernel='quartic')
}
\arguments{
\item{pts1,pts2}{
Point data sets
}
\item{poly}{
A polygon data set
}
\item{h1,h2}{
The kernel width parameters, \fCh1} for \fCpts1}, and \fCh2} for \fCpts2}
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
\(bu \fC$z} A matrix of dimension \fCnx} by \fCny} containing the ratio of the kernel functions.
\(bu \fC$h} A vector of length 2 containing \fCh1} and \fCh2}
\(bu \fC$kernel} a character string containing the kernel name.


}
\seealso{
kernel2d, mse2d
}
\references{
Berman M. and Diggle P.J. (1989) Estimating Weighted Integrals of the
Second-Order Intensity of Spatial Point Patterns.
\emph{J. R. Statist Soc} B51 81-92
}
% Converted by Sd2Rd version 0.3-3.
