\name{nndistF}
\alias{nndistF}
\title{
Nearest neighbour distances as used by Fhat()
}
\description{
Calculate nearest neighbour distances as used by  \code{Fhat()}
}
\usage{
nndistF(pts1,pts2)
}
\arguments{
\item{pts1}{
A points data set
}
\item{pts2}{
A points data set
}}
\value{
The set of distances from each of the points in \code{pts2} to the nearest
point in \code{pts1} is returned as a vector.


}
\seealso{
\code{nndistG},\code{Fhat},\code{Ghat},\code{Fzero}
}
\examples{
data(uganda)
boxplot(nndistF(as.points(uganda), as.points(csr(uganda$poly, length(uganda$x)))))
library(stepfun)
plot(ecdf(nndistF(as.points(uganda), as.points(csr(uganda$poly, length(uganda$x))))),main="Fhat ecdf Uganda volcano data")
}
% Converted by Sd2Rd version 0.3-3.
