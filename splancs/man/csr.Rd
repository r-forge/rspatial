\name{csr}
\alias{csr}
\title{
Simulations
}
\description{
Generate completely spatially random points on a polygon.
}
\usage{
csr(poly,npoints)
}
\arguments{
\item{poly}{
A polygon data set.
}
\item{npoints}{
The number of points to generate.
}}
\value{
 A point data set consisting of \code{npoints} points distributed randomly,
i.e. as an independent random sample from the uniform distribution
in the polygon defined by \code{poly}.


}
\section{METHOD}{
\code{csr} generates points randomly in the bounding box of \code{poly,} then uses 
\code{pip} to extract those in the polygon. If the number of points remaining is
less than that required, \code{csr} generates some more points in the
bounding box until at least \code{npoints} remain inside the polygon. If too many
points are generated then the list of points is truncated.
}
\section{Side Effects}{
Uses \code{runif()} to generate random numbers and so updates \code{.Random.seed},
the standard S random number generator seed.
}
% Converted by Sd2Rd version 0.3-3.
