\name{secal}
\alias{secal}
\title{
Point Summary Statistics
}
\description{
Calculate standard errors for the difference between two K-functions under
random labelling of the corresponding two sets of points.
}
\usage{
secal(pts1,pts2,poly,s)
}
\arguments{
\item{pts1,pts2}{
Two point data sets
}
\item{poly}{
Polygon enclosing the points in \fCpts1} and \fCpts2}
}
\item{s}{
A vector of distances at which to calculate the standard error.
}}
\value{
A vector like \fCs} containing the value of the standard error at each of the
distances in \fCs}


}
\section{METHOD}{
To compare two point patterns, one can calculate the difference between
their K-functions. The function \fCsecal} gives the pointwise standard 
errors for the estimated differences, under the random labelling hypothesis.
}
\references{
Diggle P.J. and Chetwynd A.G. (1991) Second-order analysis of spatial 
clustering
\emph{Biometrics 47} 1155--63 
}
\seealso{
\fCkhat}
}
% Converted by Sd2Rd version 0.3-3.
