\name{mse2d}
\alias{mse2d}
\title{
Mean Square Error for a Kernel Smoothing
}
\description{
Estimate the Mean Square Error for a Kernel Smoothing.
}
\usage{
mse2d(pts,poly,nsmse, range)
}
\arguments{
\item{pts}{
A set of points.
}
\item{poly}{
A polygon containng the points.
}
\item{nsmse}{
Number of steps of \code{h} at which to calculate the mean square error.
}
\item{range}{
Maximum value of \code{h} for calculating the mean square error.
}}
\value{
A list with two components, \code{$h} and \code{$mse}. These vectors store
corresponding values of the mean square error at values of the kernel
smoothing parameter, \code{h}. 
The value of \code{h} corresponding to the minimum value of \code{$mse}
can be passed to \code{kernel2d} as the optimum smoothing parameter.


}
\references{
Berman M. \& Diggle P.J. (1989) Estimating Weighted Integrals of the
Second-Order Intensity of a Spatial Point Pattern. 
\emph{ J. R. Statist Soc} B 51 81--92
}
\examples{
data(bodmin)
Mse2d <- mse2d(as.points(bodmin), bodmin$poly, nsmse=50, range=8)
plot(Mse2d$h[5:50],Mse2d$mse[5:50], type="l")
}
\seealso{
\code{kernel2d}


}
% Converted by Sd2Rd version 0.3-3.
