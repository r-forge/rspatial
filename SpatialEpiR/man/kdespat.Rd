\name{kdespat}

\alias{kdespat}

\title{Kernel density estimation}

\description{
Calculates a spatial kernel density estimate of a point dataset - with and
without edge-corrections, within a polygon or not, on a grid or not ... in
other words a quite flexible function.
}

\usage{
kdespat(pts, h, poly = NA, kernel = "normal", grid = TRUE, x = NA,
                    y = NA, nx = NA, ny = NA, edge = TRUE, scale = TRUE,
                    innerpoly = NA, rings = 10, npt = 10*rings)
}

\arguments{
\item{pts}{A point dataset.}
\item{h}{A bandwidth parameter.}
\item{poly}{A polygon containing the points.}
\item{kernel}{A choice of kernel (either "normal" or "quartic").}
\item{grid}{Logical value. If true, the estimate is calculated on a grid - this
being determined either by the specified x- and y-coordinates or by the sizes
nx and ny.} 
\item{x}{If grid=TRUE this (if stated) should be a vector of EQUALLY SPACED 
values that cover the x-range of the data - used to construct the grid.
If grid=FALSE this should be a vector of x-coordinates which in combination 
with y constitutes the points in which the estimate is calculated.}
\item{y}{Like x, but for the y-coordinates.}
\item{nx}{If grid=T and x and y are not stated this specifies the size of the 
grid - if it is not stated, the function does by default something sensible (at
least 20 depending on the size of h - the smaller h the larger nx).}
\item{ny}{Like nx, but for the y-coordinates.}
\item{edge}{Logical value. If true, edge-corrections are performed. However this
is only done if the POLYGON is SPECIFIED.}
\item{scale}{Logical value. If true, the estimate of the density will be scaled 
to integrate to 1. Usually this is the case anyway and hence the scaling is 
often unnecessary!! The option is only available if edge=TRUE, grid=TRUE and 
the grid is chosen fine enough.}
\item{innerpoly}{An inner polygon in which no edge-corrections are performed. 
This is optional but only makes sense if edge=TRUE. If the specified poly is 
not rectangular the edge-corrections becomes much more computer intensive and 
this is then a way to speed the process up - the philosophy being that the 
edge-corrections only negligible affect the density estimate in the middle of 
the polygon. The smaller h the larger the innerpoly can be. (Only really 
suitable for the "quartic" kernel).}
\item{rings}{The larger this number is the more accurate are the 
edge-corrections - the default of 10 should be god enough in most cases. This 
option is only used if edge=T and the poly is not rectangular.}
\item{npt}{The larger this number is the more accurate are the 
edge-corrections - the default should be adequate. Again this option is only 
used if edge=TRUE and the poly is not rectangular.}
}


\examples{
data(southlancs)

cases<-southlancs.pts[southlancs.cc==1,]
controls<-southlancs.pts[southlancs.cc==0,]

#Compute the intensity at the cases using the controls
kdespat(controls, 1700, poly=southlancs.bdy, grid=FALSE, x=cases[,1],
   y=cases[,2], scale=FALSE)
}


\references{

}


\keyword{

}
