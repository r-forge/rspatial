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


Either \fCnpts} or \fCxs} and \fCys} must be specified. If all three
are given then \fCxs} and \fCys} are ignored. 
}}
\value{
A points object containing a grid of points inside the polygon. If \fCnpts}
is specified, then a grid spacing \fCxs} and \fCys} will be calculated to give
approximately \fCnpts} in the polygon. If \fCxs} and \fCys} are given then these
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
