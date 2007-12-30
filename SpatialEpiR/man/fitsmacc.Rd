\name{fitsmacc}

\alias{fitsmacc}

\title{Estimate parameters and risk-surface in a GAM using case-control data}

\description{
'fitsmacc' estimates the parameters and the risk-surface in the GAM
described in Kelsall and Diggle (1998) and Jarner et al. (2002) for a spatial (matched or unmatched) case-control points dataset. An
iterative estimation algorithm is used applying kernel smoothing for the
non-parametric part and maksimum likelihood for the linear part.
}


\usage{
fitsmacc(pts, poly, cc, hvals, matched, covmat = NULL, sztup =
NA, edge = TRUE, scale = FALSE, ngrid = 4000, outermax = 50, innermax =
100, tolbeta = 1e-05, tolg = 0.1, rings = 10, denspts = 10 * rings)
}

\arguments{
\item{pts}{The points dataset.}
\item{poly}{The polygon containing the points.}
\item{cc}{A vector of 0 and 1's -- 1 if it corresponds to a case, 0 if to
a control.} 
\item{hvals}{A vector of possible bandwidth parameters from which the 'optimal' is chosen.}
\item{matched}{Boolean -- TRUE if the data is matched, FALSE if not.}
\item{covmat}{A matrix containing the covariates (column-wise) - not including a constant term!}
\item{sztup}{The tuple size -- if the study is matched}
\item{edge}{Boolean -- if T edgecorrections are performed, if F they are not.}
\item{scale}{Boolean -- if T all the covariates are scaled to have mean 0
and standard deviation 1. This is advised if any of the covariates take on
'large' values.}
\item{ngrid}{}
\item{outermax}{}
\item{innermax}{}
\item{tolbeta}{}
\item{tolg}{}
\item{rings}{}
\item{denspts}{}
}

\examples{

}

\references{
Jarner,M.J., Diggle,P.J. and Chetwynd,A. (2002). Estimation of spatial
variation in risk using matched case-control data. Biometrical Journal
44:936-945.

Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of
disease: A nonparametric binary regression approach. Applied Statistics,
47(4):559-573.
}

\keyword{}
