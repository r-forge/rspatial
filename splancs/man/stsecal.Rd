\name{stsecal}
\alias{stsecal}
\title{
Space-time Clustering Analysis
}
\description{
Computes the standard error for space-time clustering.
}
\usage{
stsecal(pts, times, poly, tlim, s, tm)
}
\arguments{
\item{pts}{
A set of points, as defined in Splancs.
}
\item{times}{
A vector of times, the same length as the number of points in \fCpts}
}
\item{poly}{
A polygon enclosing the points
}
\item{tlim}{
A vector of length 2 specifying the upper and lower temporal domain.
}
\item{s}{
A vector of spatial distances for the analysis
}
\item{tm}{
A vector of times for the analysis
}}
\value{
A matrix of dimension \fC[length(s),length(t)]} is returned. Element 
\fC[i,j]} is the standard error at \fCs[i],t[j]}.
See Diggle Chetwynd Haggkvist and Morris (1993)for details.
}
\seealso{
stkhat, stsecal, stvmat, stdiagn
}
% Converted by Sd2Rd version 0.3-3.
