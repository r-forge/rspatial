\name{kernrat}
\alias{kernrat}
\title{
Ratio of two kernel smoothings
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
The kernel width parameters, \code{h1} for \code{pts1}, and \code{h2} for \code{pts2}
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
\(bu \code{$x} List of x-coordinates at which the kernel function has been evaluated.
\(bu \code{$y} List of y-coordinates at which the kernel function has been evaluated.
\(bu \code{$z} A matrix of dimension \code{nx} by \code{ny} containing the ratio of the kernel functions.
\(bu \code{$h} A vector of length 2 containing \code{h1} and \code{h2}
\(bu \code{$kernel} a character string containing the kernel name.


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
