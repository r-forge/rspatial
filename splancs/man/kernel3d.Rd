\name{kernel3d}
\alias{kernel3d}
\title{
Space-time kernel functions
}
\description{
Compute the space-time kernel
}
\usage{
kernel3d(pts, times, xgr, ygr, tgr, hxy, ht)
}
\arguments{
\item{pts}{
A matrix of event coodinates x,y.
}
\item{times}{
A vector of event times, t.
}
\item{xgr}{
The values of x at which to compute the kernel function.
}
\item{ygr}{
The values of y at which to compute the kernel function.
}
\item{tgr}{
The values of t at which to compute the kernel function.
}
\item{hxy}{
The quartic kernel width in the x and y direction.
}
\item{ht}{
The quartic kernel width in the temporal direction.
}}
\value{
A list is returned. Most of the components are just copies of the 
input parameters, except for the \code{$v} parameter.
This is a three dimensional array containing the kernel-smoothed
values. Its dimension is
\code{[length(xgr),length(ygr),length(tgr)]}. 
}
\seealso{
kerview
}
% Converted by Sd2Rd version 0.3-3.
