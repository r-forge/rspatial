\name{siggam}

\alias{siggam}
\alias{siggamfinish}
\alias{siggamstart}

\title{Relabeling test for fitloggam.}

\description{
'siggam' relabels the cases and controls and fits the surface for the new
data set keeping track of previous simulations. For calculating the
tolerance contours this function should be called 99 times feeding
previous simulations to the next one. If loops were less of a pain in
Splus this could easily have been done for you - sorry.

When the points have been relabed, function fitloggam is computed on the
new set of cases and controls.

'siggamstart'  sets things up for doing signicance.

'siggamfinish'  gathers the information produced by fitloggam and the
final siggam and assembles it in a list ready to feed to plotrisk for
plotting.
}

\usage{
siggam(formula, cc, pts, poly, start, prev.sims = NULL)
siggamstart(formula, cc, pts, h, poly,ngrid)
siggamfinish(poly, gamfit, lastsim)
}

\arguments{
\item{formula}{A formula of the form cc~covars  - the nonlinear/smooth
part should not be included here since it is automatically implemented. If
there are no covariates write: cc~1}
\item{cc}{A vector of 0's and 1's to represent the cases and controls.}
\item{pts}{A point dataset.}
\item{poly}{A polygon containing the points.}
\item{start}{List containing some parameters used in the simulations. The following values
must be included:
	\item{tvalobs}{Observed value of the test statistic.}
	\item{surf.est}{Estimated surfave with the observed data.}
	\item{x}{x-values of the points where the surface has been estimated.}
	\item{y}{y-values of the points where the surface has been estimated.}
	\item{prob}{}
	\item{h}{A bandwidth parameter.}
}
\item{prev.sims}{List containing summary statistics of previous simulations. It must contain:
	\item{tval}{Previous values of the test statistics under random
relabeling.}
	\item{tvalobs}{Observed value of the test statistic.}
	\item{pval}{P-value of the test statistic.}
	\item{sigmat}{Point-wise, the number of times that the re-estimated
values of the surface are lower than the value for the observed data.}
	\item{x}{x-values of the points where the surface has been estimated.}
	\item{y}{y-values of the points where the surface has been estimated.}
 }
\item{ngrid}{Approximate number of points in the grid.}
\item{h}{A bandwidth parameter.}
\item{gamfit}{An object returned by fitloggam.}
\item{lastsim}{Results from final call to siggam.}
}

\examples{

}

\references{
Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of
disease: A nonparametric binary regression approach. Applied Statistics,
47(4):559-573.
}

\keyword{}
