\name{mse2d}
\alias{mse2d}
\title{
Point Operations.
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
Number of steps of \fCh} at which to calculate the mean square error.
}
\item{range}{
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
\examples{
data(bodmin)
Mse2d <- mse2d(as.points(bodmin), bodmin$poly, nsmse=50, range=8)
plot(Mse2d$h[5:50],Mse2d$mse[5:50], type="l")
}
\seealso{
\fCkernel2d}


}
% Converted by Sd2Rd version 0.3-3.
