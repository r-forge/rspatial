\name{mpoint}
\alias{mpoint}
\title{
Graphics
}
\description{
Overlay a number of point patterns.
}
\usage{
mpoint(\dots,cpch,add=F,type="p")
}
\arguments{
\item{...}{
At least one argument consisting of a points data set must be specified.
}
\item{cpch}{
A vector of characters for plotting symbols
}
\item{add}{
if \code{add} is \code{TRUE} then overlay on an existing plot
}
\item{type}{
plot data as points if \code{type="p"}, lines if \code{type="l"}


}}
\section{Side Effects}{
\code{mpoint} enables several point or polygon datasets to be overlayed. The plot
region is calculated so that all the specified datasets fit in the region.
The parameter \code{cpch} specifies the characters to use for each set of points. The
default \code{cpch} consists of the numbers 1 to 9 followed by the uppercase 
letters A to Z. If \code{cpch} is shorter than the number of point sets to
plot, then it is repeated.
}
\seealso{
\code{pointmap}
}
\examples{
mpoint(rabbit1,rabbit2,cpch=c("1","2"))
}
% Converted by Sd2Rd version 0.3-3.
