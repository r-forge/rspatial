\name{khvc}
\alias{khvc}
\title{
Point summary statistics
}
\description{
Calculate the covariance matrix for the difference between two K-functions.
Also return the contribution to the variance for each of the two point
patterns,
}
\usage{
khvc(pts1, pts2, poly, s)
}
\arguments{
\item{pts1}{
An object containing the case locations.
}
\item{pts2}{
An object containing the control locations.
}
\item{poly}{
A polygon enclosing the locations in \fCpts1} and \fCpts2}
}
\item{s}{
A vector of distances at which the calculation is to be made.
}}
\value{
A list with four components:
\(bu \fC$varmat} The upper triangle of the covariance matrix.
\(bu \fC$k11} The variance of Khat for the cases
\(bu \fC$k22} The variance of Khat for the controls
\(bu \fC$k12} The covariance of Khat for the cases and Khat for controls.
}
\section{Note}{
Note that the diagonal of the covariance matrix is
 \fC$k11 - 2 * $k12 + $k22
}
\seealso{
khat, khvmat, secal


}
% Converted by Sd2Rd version 0.3-3.
