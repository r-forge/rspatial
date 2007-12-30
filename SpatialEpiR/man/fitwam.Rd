\name{fitwam}

\alias{fitwam}

\title{}

\description{
Fits a weighted additive model for the specified adjusted dependent
variable, z and the weights, w following the scheme of Kelsall and
Diggle(1998). This function is called 10 times by the function fitloggam
to fit a logistic generalised additive model. The estimated beta and h
values are printed along the way such that convergence can be assessed.
}

\usage{
fitwam(formula, g1, g2, z, w, fhat, phat, yvec, pts, poly,
                   hvals, hopt0 = NA, ngrid = 2000)
}

\arguments{
\item{formula}{The formula of the linear fit.}
\item{g1}{Vector of reals; the linear (fitted) function.}
\item{g2}{Vector of reals; the smooth (fitted) function.}
\item{z}{Vector of reals; adjusted dependent variable.}
\item{w}{Vector of reals; weights from the generalised bit.}
\item{fhat}{g1+g2; the (fitted) linear predictor of the model.}
\item{phat}{A vector of estimated probabilities.}
\item{yvec}{Vector of responses.}
\item{pts}{A point dataset holding the spatial locations of the cases and controls.}
\item{poly}{A polygon containing the points.}
\item{hvals}{A vector of length 5, 10, 15 or 20 with possible good values
for h, the bandwidth parameter, eg exp(seq(log(100),log(4000),length = 15))}
\item{hopt0}{Single real value for the kernel regression to use as
bandwidth parameter. In the first iteration it should be left as NA and
then defined as the previous value in the subsequent calls.}
\item{ngrid}{Number of points in the grid. Usually only used as
non-default value at the last iteration to ensure a finer answer for the
final plot.}
}

\references{
Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of
disease: A nonparametric binary regression approach. Applied Statistics,
47(4):559-573.
}

\keyword{}
