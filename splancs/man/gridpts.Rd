\name{gridpts}
\alias{gridpts}
\title{
Generate a grid of points
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
% Converted by Sd2Rd version 0.3-3.
