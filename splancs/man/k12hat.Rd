\name{k12hat}
\alias{k12hat}
\title{
Point Summary Statistics
}
\description{
Calculates an estimate of the bivariate K-function
}
\usage{
k12hat(pts1,pts2,poly,s)
}
\arguments{
\item{pts1,pts2}{
Two points data sets
}
\item{poly}{
A polygon containing the points
}
\item{s}{
A vector of distances at which to estimate the K12 function
}}
\value{
A vector like \code{s} containing the value of K12hat at the points in \code{s}.


}
\section{METHOD}{
The bivariate K function is defined as the expected number of points of
pattern 1
within a distance s of an arbitrary point of pattern 2, divided by the
overall density of the points in pattern 1.  To estimate this function,
the approximately unbiased estimator given by Lotwick and Silverman
(1982) is used.
}
\references{
Lotwick, H.W. and Silverman B.W. (1982) Methods for Analysing Spatial
Processes of Several types of Points.
\emph{J. R. Statist Soc} B44 406-13
