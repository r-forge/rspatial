\name{classIntervals}
\alias{classIntervals}
\alias{print.classIntervals}
\alias{plot.classIntervals}
\alias{nPartitions}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Choose univariate class intervals}
\description{
  The function provides a uniform interface to finding class intervals for continuous numerical variables, for example for choosing colours or symbols for plotting. Class intervals are non-overlapping, and the classes are left-closed --- see \code{findInterval}. Argument values to the style chosen are passed through the dot arguments.
}
\usage{
classIntervals(var, n, style = "quantile", rtimes = 3, ...)
plot.classIntervals(x, pal, ...) 
print.classIntervals(x, ...) 
nPartitions(x) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{var}{a continuous numerical variable}
  \item{n}{number of classes required, if missing, \code{nclass.Sturges} is used}
  \item{style}{chosen style: one of "fixed", "sd", "equal", "pretty", "quantile", "kmeans", "hclust" or "bclust"}
  \item{rtimes}{number of replications of var to catenate and jitter; may be used with styles "kmeans" or "bclust" in case they have difficulties reaching a classification}
  \item{\dots}{arguments to be passed to the functions called in each style}
  \item{x}{"classIntervals" object for printing or plotting}
  \item{pal}{a character vector of at least two colour names for colour coding the class intervals in an ECDF plot; \code{colorRampPalette} is used internally to create the correct number of colours}
}
\details{
  The "fixed" style permits a "classIntervals" object to be specified with given breaks, set in the \code{fixedBreaks} argument; the length of \code{fixedBreaks} should be n+1; this style can be used to insert rounded break values.

  The "sd" style chooses breaks based on \code{pretty} of the centred and scaled variables, and may have a number of classes different from n; the returned \code{par=} includes the centre and scale values.

  The "equal" style divides the range of the variable into n parts.

  The "pretty" style chooses a number of breaks not necessarily equal to n using \code{pretty}, but likely to be legible; arguments to \code{pretty} may be passed through \code{\dots}.

  The "quantile" style provides quantile breaks; arguments to \code{quantile} may be passed through \code{\dots}.

  The "kmeans" style uses \code{kmeans} to generate the breaks; it may be anchored using \code{set.seed}; the \code{pars} attribute returns the kmeans object generated; if \code{kmeans} fails, a jittered input vector containing \code{rtimes} replications of \code{var} is tried --- with few unique values in \code{var}, this can prove necessary; arguments to \code{kmeans} may be passed through \code{\dots}.

  The "hclust" style uses \code{hclust} to generate the breaks using hierarchical clustering; the \code{pars} attribute returns the hclust object generated, and can be used to find other breaks using \code{getHclustClassIntervals}; arguments to \code{hclust} may be passed through \code{\dots}.

  The "bclust" style uses \code{bclust} to generate the breaks using bagged clustering; it may be anchored using \code{set.seed}; the \code{pars} attribute returns the bclust object generated, and can be used to find other breaks using \code{getBclustClassIntervals}; if \code{bclust} fails, a jittered input vector containing \code{rtimes} replications of \code{var} is tried --- with few unique values in \code{var}, this can prove necessary; arguments to \code{bclust} may be passed through \code{\dots}.
}

\value{
 an object of class "classIntervals":
  \item{var}{the input variable}
  \item{brks}{a vector of breaks}
  and attributes:
  \item{style}{the style used}
  \item{parameters}{parameter values used in finding breaks}
  \item{nobs}{number of different finite values in the input variable}
  \item{call}{this function's call}
}
\references{Armstrong, M. P., Xiao, N., Bennett, D. A., 2003. "Using genetic algorithms to create multicriteria class intervals for choropleth maps". Annals, Association of American Geographers, 93 (3), 595--623; Jenks, G. F., Caspall, F. C., 1971. "Error on choroplethic maps: definition, measurement, reduction". Annals, Association of American Geographers, 61 (2), 217--244; Dent, B. D., 1999, Cartography: thematic map design. McGraw-Hill, Boston, 417 pp.}

\author{Roger Bivand <Roger.Bivand@nhh.no>}

\seealso{\code{\link{pretty}}, \code{\link[stats]{quantile}}, \code{\link[stats]{kmeans}}, \code{\link[stats]{hclust}}, \code{\link[e1071]{bclust}}, \code{\link{findInterval}}, \code{\link[grDevices]{colorRampPalette}}, \code{\link[grDevices]{nclass.Sturges}}}
\examples{
data(jenks71)
pal1 <- c("wheat1", "red3")
opar <- par(mfrow=c(3,3))
plot(classIntervals(jenks71$jenks71, n=5, style="fixed", fixedBreaks=c(15.57, 25, 50, 75, 100, 155.30)), pal=pal1, main="Fixed")
plot(classIntervals(jenks71$jenks71, n=5, style="sd"), pal=pal1, main="Pretty standard deviations")
plot(classIntervals(jenks71$jenks71, n=5, style="equal"), pal=pal1, main="Equal intervals")
plot(classIntervals(jenks71$jenks71, n=5, style="quantile"), pal=pal1, main="Quantile")
set.seed(1)
plot(classIntervals(jenks71$jenks71, n=5, style="kmeans"), pal=pal1, main="K-means")
plot(classIntervals(jenks71$jenks71, n=5, style="hclust", method="complete"), pal=pal1, main="Complete cluster")
plot(classIntervals(jenks71$jenks71, n=5, style="hclust", method="single"), pal=pal1, main="Single cluster")
set.seed(1)
plot(classIntervals(jenks71$jenks71, n=5, style="bclust", verbose=FALSE), pal=pal1, main="Bagged cluster")
plot(classIntervals(jenks71$jenks71, n=5, style="bclust", hclust.method="complete", verbose=FALSE), pal=pal1, main="Bagged complete cluster")
par(opar)
classIntervals(jenks71$jenks71, n=5, style="fixed", fixedBreaks=c(15.57, 25, 50, 75, 100, 155.30))
classIntervals(jenks71$jenks71, n=5, style="sd")
classIntervals(jenks71$jenks71, n=5, style="equal")
classIntervals(jenks71$jenks71, n=5, style="quantile")
set.seed(1)
classIntervals(jenks71$jenks71, n=5, style="kmeans")
classIntervals(jenks71$jenks71, n=5, style="hclust", method="complete")
classIntervals(jenks71$jenks71, n=5, style="hclust", method="single")
set.seed(1)
classIntervals(jenks71$jenks71, n=5, style="bclust", verbose=FALSE)
classIntervals(jenks71$jenks71, n=5, style="bclust", hclust.method="complete", verbose=FALSE)
}
\keyword{spatial}

