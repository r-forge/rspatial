\name{gridpts}
\alias{gridpts}
\title{
Point Operations
}
\description{
Generate a grid of points
}
\usage{
gridpts(poly,npts,xs,ys)
}
\arguments{
\item{poly}{
polygon in which to generate the points
}
\item{npts}{
approximate number of points to generate
}
\item{xs,ys}{
grid spacing in x and y 


Either \code{npts} or \code{xs} and \code{ys} must be specified. If all three
are given then \code{xs} and \code{ys} are ignored. 
}}
\value{
A points object containing a grid of points inside the polygon. If \code{npts}
is specified, then a grid spacing \code{xs} and \code{ys} will be calculated to give
approximately \code{npts} in the polygon. If \code{xs} and \code{ys} are given then these
will be used to generate a number of points in the polygon.


}
\examples{
lancs.grid1 <- gridpts(lancs.poly,100)    # generate approx 100 points in lancs
npts(lancs.grid1)                         # not necessarily 100, but close
lancs.grid2 <- gridpts(lancs.poly,xs=5,ys=6) # generate a rectangular grid
npts(lancs.grid2)                         # exact number will depend on 
#shape of polygon


}
% Converted by Sd2Rd version 0.3-3.
