\name{khat}
\alias{khat}
\title{
Point Summary Statistics
}
\description{
Calculates an estimate of the K-function
}
\usage{
khat(pts,poly,s)
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon containing the points
}
\item{s}{
A vector of distances at which to calculate the K function
}}
\value{
A vector like \code{s} containing the value of K at the points in \code{s}.


}
\section{METHOD}{
The K function is defined as the expected number of further points
within a distance s of an arbitrary point, divided by the
overall density of the points. 
In practice an edge-correction is required to avoid biasing the
estimation due to non-recording of points outside the polygon.
}
\references{
Ripley, B.D. The second-order analysis of stationary point processes,
\emph{ J. Appl. Prob, 13} 255-266
}
% Converted by Sd2Rd version 0.3-3.
