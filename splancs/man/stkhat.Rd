\name{stkhat}
\alias{stkhat}
\title{
Space-time K-functions
}
\description{
Compute the space-time K-functions
}
\usage{
stkhat(pts, times, poly, tlimits, s, tm)
}
\arguments{
\item{pts}{
A set of points as defined in Splancs
}
\item{times}{
A vector of times, the same length as the number of points in \code{pts}
}
\item{poly}{
A polygon enclosing the points
}
\item{tlimits}{
A vector of length 2 specifying the upper and lower temporal domain.
}
\item{s}{
A vector of spatial distances for the analysis.
}
\item{tm}{
A vector of times for the analysis
}}
\value{
A list with the following components is returned:
\(bu \code{$s  $t} The spatial and temporal scales
\(bu \code{$ks} The spatial K-function
\(bu \code{$kt} The temporal K-function
\(bu \code{$kst} The space-time K-function
For details see Diggle, Chetwynd, Haggkvist, and Morris (1993)
}
\seealso{
stsecal, stvmat, stmctest, stdiagn


}
% Converted by Sd2Rd version 0.3-3.
