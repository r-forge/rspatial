\name{mse2d}
\alias{mse2d}
\title{
Point Operations.
}
\description{
Estimate the Mean Square Error for a Kernel Smoothing.
}
\usage{
mse2d(pts,poly,nsteps,hrange)
}
\arguments{
\item{pts}{
A set of points.
}
\item{poly}{
A polygon containng the points.
}
\item{nsteps}{
Number of steps of \fCh} at which to calculate the mean square error.
}
\item{hrange}{
Maximum value of \fCh} for calculating the mean square error.
}}
\value{
A list with two components, \fC$h} and \fC$mse}. These vectors store
corresponding values of the mean square error at values of the kernel
smoothing parameter, \fCh}. 
The value of \fCh} corresponding to the minimum value of \fC$mse}
can be passed to \fCkernel2d} as the optimum smoothing parameter.


}
\references{
Berman M. \& Diggle P.J. (1989) Estimating Weighted Integrals of the
Second-Order Intensity of a Spatial Point Pattern. 
\emph{ J. R. Statist Soc} B 51 81--92
}
\seealso{
\fCkernel2d}


}
% Converted by Sd2Rd version 0.3-3.
