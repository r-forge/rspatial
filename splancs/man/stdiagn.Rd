\name{stdiagn}
\alias{stdiagn}
\title{
Summary plots for clustering analysis
}
\description{
Produces some summary plots for clustering analysis
}
\usage{
stdiagn(pts, stkh, stse, stmc=0)
}
\arguments{
\item{pts}{
A set of points, as used in Splancs
}
\item{stkh}{
An object returned from \code{stkhat}
}
\item{stse}{
An object returned from \code{stsecal}
}
\item{stmc}{
An object returned from \code{stmctest}
}}
\details{
Four plots are produced on the current graphics device.
The first plot is simply a map of the data. The second is a perspective plot
of the difference between space-time K-function and the product of spatial
and temporal K-functions. The third plot is of the 
standardised residuals against the product of spatial and temporal
K-functions. If the Monte-Carlo data is given the fourth plot is a
a histogram of the test statistics, with the value for the data indicated
with a vertical line.
See Diggle, Chetwynd, Haggkvist, and Morris (1993) for details.
}
\seealso{
stkhat, stsecal, stvmat, stmctest
}
% Converted by Sd2Rd version 0.3-3.
