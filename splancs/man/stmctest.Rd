\name{stmctest}
\alias{stmctest}
\title{
Space-time Clustering
}
\description{
Perform a Monte-Carlo test of space-time clustering.
}
\usage{
stmctest(pts, times, poly, tlimits, s, tt, nsim, quiet=F)
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
If \code{quiet=T} then no output is produced, otherwise the function
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
See Diggle, Chetwynd, Haggkvist and Morris (1993) for details.
}
\seealso{
stkhat, stsecal, stvmat, stdiagn
}
% Converted by Sd2Rd version 0.3-3.
