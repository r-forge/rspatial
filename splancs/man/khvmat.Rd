\name{khvmat}
\alias{khvmat}
\title{
Point Summary Statistics
}
\description{
Calculate the covariance matrix for the difference between two K-functions 
under random labelling of the corresponding two sets of points.
}
\usage{
khvmat(pts1, pts2, poly, s)
}
\arguments{
\item{pts1}{
An object containing the case locations.
}
\item{pts2}{
An object containing the control locations.
}
\item{poly}{
Polygon enclosing the points in pts1 and pts2.
}
\item{s}{
A vector of distances at which the calculation is to be made.
}}
\value{
A matrix containing the covariances, with the variances on the diagonal.
}
\references{
Diggle P.J and Chetwynd A.C (1991) Second order analysis of
spatial clustering Biometrics 47 1155-63
}
\seealso{
\code{secal}
}
% Converted by Sd2Rd version 0.3-3.


