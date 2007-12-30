\name{fitloggam}
\alias{fitloggam}

\title{Fits a logistic generalised additive model using Kelsall and Diggle(1998)}

\description{
Fits a logistic generalised additive model following the iterative scheme
in Kelsall and Diggle(1998). This function calls fitwam 10 times, which in
turn fits a weighted additive model to the current adjusted dependent
variable. In each iteration the results are printed to the screen such
that convergence can be assessed.
}

\usage{
fitloggam(formula, cc, pts, hvals, poly, ngrid=4000)
}

\arguments{
\item{formula}{A formula of the form cc~covars  - the nonlinear/smooth
part should not be included here since it is automatically implemented. If
there are no covariates write: cc~1}
\item{cc}{A vector of 0's and 1's to represent the cases and controls.}
\item{pts}{A point dataset.}
\item{hvals}{A vector of length 1, 5, 10, 15 or 20 with possible good
values for h, the bandwidth parameter; eg. exp(seq(log(100),log(4000),length = 15))}
\item{poly}{A polygon containing the points.}
\item{ngrid}{The approximate number of grid points used.}
}

\examples{
data(southlancs)

fitloggam(cc~1, cc=1-southlancs.cc, hvals=1700, 
  southlancs.pts, southlancs.bdy)
}

\references{
Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of
disease: A nonparametric binary regression approach. Applied Statistics,
47(4):559-573.  }

\seealso{fitwam}

\keyword{}
