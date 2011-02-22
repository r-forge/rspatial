\name{tolsmacc}
\alias{tolsmacc}

\title{Compute tolerance contours of the risk surface using matched data}

\description{
'tolsmacc' calculates 95\% tolerance contours of the risk-surface
estimated by the function 'fitsmacc'. A Monte Carlo method is used,
relabelling the cases and controls under the null hypothesis of no spatial
variation in risk (g=0) and then re-estimating the surface for the new
datasets. In each point the proportion of surfaces with a value smaller
than that of the original surface is calculated and it is the 0.025 and
0.975 contours of this probability-surface that are finally used.
}

\usage{
tolsmacc(pts, poly, cc, h, matched, nsim, surfacels, meansurface, tzero,
covmat = NULL, sztup = NA, edge = TRUE, scale = FALSE, outermax = 50,
innermax = 100, tolbeta = 1e-05, tolg = 0.1, rings = 10, 
denspts = 10 * rings, randomseed = -3547547)
}

\arguments{
\item{pts}{The original points dataset.}
\item{poly}{The polygon containing the points.}
\item{cc}{A vector of 0 and 1's -- 1 if it corresponds to a case, 0 if to a control.}
\item{h}{The bandwidth parameter used to estimate the 'true' surface.}
\item{matched}{Boolean - TRUE if the data is matched, FALSE if not.}
\item{nsim}{The number of re-estimations to be performed.}
\item{surfacels}{The fitted surface (x,y,z); after call to fitsmacc
'surface' in the returned list contains this.}
\item{meansurface}{The mean value of the estimated surface in
the original points; again a variable with this name and information is
given after a call to fitsmacc.}
\item{tzero}{Value of the test statistic for the original surface.}
\item{covmat}{A matrix containing the covariates (column-wise) - not including a constant term!}
\item{sztup}{The tuple size -- if the study is matched.}
\item{edge}{Boolean -- if TRUE edgecorrections are performed, if FALSE they are not.}
\item{scale}{Boolean -- if TRUE all the covariates are scaled to have mean 0 and standard deviation 1; scaling is advised if any of the covariates take on 'large' values.}
\item{outermax}{}
\item{innermax}{}
\item{tolbeta}{}
\item{tolg}{}
\item{rings}{}
\item{denspts}{}
\item{randomseed}{}
}


\examples{

}

\keyword{}
