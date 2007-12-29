\name{hch2d}

\alias{hch2d}
\alias{cvkreg2d}

\title{Bandwidth estimation using weighted least squares cross-validation}

\description{
'cvkreg2d' evaluates a weighted version of a least squares cross-validation
criterion for a two-dimensional kernel regression with the bandwidth given in
h. The criterion is described in more detail as CV5 in Kelsall and Diggle(1998).

'hch2d' runs the function cvkreg2d on a vector of h values and singles out the
one that minimises the weighted least squares cross-validation criterion for
kernel regression. For computational reasons the length of hvals should be
either 1, 5, 10, 15 or 20.
}

\usage{
cvkreg2d(pts, h, y, w = rep(1, length(y)))
hch2d(pts, hvals, y, w = rep(1, length(y)), quiet = TRUE)
}

\arguments{
\item{pts}{A point dataset using the same format as in Splancs.}
\item{h}{A bandwidth parameter.}
\item{hvals}{A vector of possible bandwidth parameter values of length 1,5,10,15 or 20. The vector of h values is often chosen to be on a log scale.}
\item{y}{A vector of values to be smoothed. With binary data it should be 0's and 1's.}
\item{w}{A vector of weights. Default gives the same weight to all observations
}
\item{quiet}{Logical value. If false a matrix is printed to the screen of each value of h and its corresponding criterion value}
}

\examples{
data(southlancs)

hch2d(southlancs, seq(1000, 2000, length.out=20), southlancs.cc, quiet=FALSE)

}

\references{
Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of disease:
A nonparametric binary regression approach. Applied Statistics, 47(4):559-573.
}


\keyword{}
