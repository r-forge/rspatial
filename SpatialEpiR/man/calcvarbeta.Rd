\name{calcvarbeta}
\alias{calcvarbeta}

\title{Compute variance of linear parameters in a GAM.}

\description{
This function estimates the variances of the linear parameters in the GAM
for a spatial case-control study (matched or unmatched) as described in
(Kelsall and Diggle 1998) and (Jarner et al 2002). A Monte Carlo method is
used, relabelling the cases and the controls under the hypothesis that the
true surface is the actual estimated surface (g=g-hat), re-estimate the
surface and the linear parameters for these new datasets and finally
calculate the variance on these beta-estimates. As comparison the mean of
the variances drawn from the Fisher Information matrix for each
re-estimated surface is also returned.
}


\usage{
calcvarbeta <- function(pts, poly, cc, h, matched, nsim, covmat=NULL,
sztup=NA, edge=TRUE, scale=FALSE, outermax=50, innermax=100, tolbeta=1e-5,
tolg=1e-1, rings=10, denspts=10*rings, randomseed=-3547547) 
}

\arguments{
\item{pts}{The original point-dataset.}
\item{poly}{The polygon containing the points.}
\item{cc}{A vector of 0 and 1's -- 1 if it corresponds to a case, 0 if to a control.}
\item{h}{The bandwidth parameter used to estimate the 'true' surface.}
\item{matched}{Boolean -- TRUE if the data is matched, FALSE if not.}
\item{nsim}{The number of re-estimations to be performed.}
\item{covmat}{A matrix containing the covariates (column-wise) - not including a constant term!}
\item{sztup}{The tuple size -- if the study is matched.}
\item{edge}{Boolean -- if TRUE edgecorrections are performed, if FALSE they are not.}
\item{scale}{Boolean -- if TRUE all the covariates are scaled to have mean 0 and standard deviation 1.}
\item{outermax}{}
\item{innermax}{}
\item{tolbeta}{}
\item{tolg}{}
\item{rings}{}
\item{denspts}{}
\item{randomseed}{}
}

\references{
Jarner, M.F., Diggle, P.J. (2002). EpiS: an S library on risk estimation
and cluster detection in case–control studies. Technical Report.
Department of Mathematics and Statistics, University of Lancaster,
Lancaster. http://www.maths.lancs.ac.uk/Software/epiS/epistech.ps

Jarner,M.J., Diggle,P.J. and Chetwynd,A. (2002). Estimation of spatial
variation in risk using matched case–control data. Biometrical Journal 
44:936–945.  

Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of
disease: A nonparametric binary regression approach. Applied Statistics,
47(4):559-573.
}



\keyword{}
