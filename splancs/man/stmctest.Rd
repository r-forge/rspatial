% Copyright Barry Rowlingson  and 
% Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
% R port: copyright 1998-2000 by Roger S. Bivand

\name{stmctest}
\alias{stmctest}
\title{
Monte-Carlo test of space-time clustering
}
\description{
Perform a Monte-Carlo test of space-time clustering.
}
\usage{
stmctest(pts, times, poly, tlimits, s, tt, nsim, quiet=FALSE)
}
\arguments{
\item{pts}{
A set of points as used by Splancs.
}
\item{times}{
A vector of times, the same length as the number of points in \code{pts}.
}
\item{poly}{
A polygon enclosing the points.
}
\item{tlimits}{
A vector of length 2, specifying the upper and lower temporal domain.
}
\item{s}{
A vector of spatial distances for the analysis.
}
\item{tt}{
A vector of times for the analysis.
}
\item{nsim}{
The number of simulations to do.
}
\item{quiet}{
If \code{quiet=TRUE} then no output is produced, otherwise the function
prints the number of simulations completed so far, and also how the
test statistic for the data ranks with the simulations.
}}
\value{
A vector of length \code{nsim+1}. The first element is the test statistic
for the data, and the remaining elements are those for the simulations.
}
\details{
The function  uses a sum of residuals as a test statistic, 
randomly permutes the times of the set of points and recomputes the
test statistic for a number of simulations.
See Diggle, Chetwynd, Haggkvist and Morris (1995) for details.
}
\seealso{
\code{\link{stkhat}}, \code{\link{stsecal}}, \code{\link{stvmat}}, \code{\link{stdiagn}}
}

\references{
Diggle, P., Chetwynd, A., Haggkvist, R. and Morris, S. 1995 Second-order analysis of space-time clustering. Statistical Methods in Medical Research, 4, 124-136;Bailey, T. C. and Gatrell, A. C. 1995, Interactive spatial data analysis. Longman, Harlow, pp. 122-125;
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655;
the original sources can be accessed at:
\url{http://www.maths.lancs.ac.uk/~rowlings/Splancs/}. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}
\examples{
example(stkhat)
bur1mc <- stmctest(burpts, burkitt$t, burbdy, c(400, 5800),
  seq(1,40,2), seq(100, 1500, 100), nsim=49, quiet=TRUE)
}
% Converted by Sd2Rd version 0.3-3.
\keyword{spatial}

