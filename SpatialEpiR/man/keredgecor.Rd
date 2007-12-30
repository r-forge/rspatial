\name{keredgecor}
\alias{keredgecor}

\title{Computation of edge correction.}

\description{
Calculates edge-corrections for a kernel density estimate on a specified polygon. This function is not intended to be used directly by the user.
}

\usage{
keredgecor(h, poly, x, y, kernel = "normal", rings = 10, denspts = 10 * rings)
}

\arguments{
\item{h}{A bandwidth parameter.}
\item{poly}{A polygon containing the points.}
\item{x}{This should be a vector of x-coordinates which in combination with y
constitutes the points in which the edge-corrections are calculated.}
\item{y}{Like x, but for the y-coordinates.}
\item{kernel}{A choice of kernel (either "normal" or "quartic").}
\item{rings}{The larger this number is the more accurate are the
edge-corrections - the default of 10 should be god enough in most cases. This
option is only used if the poly is not rectangular.}
\item{denspts}{The larger this number is the more accurate are the
edge-corrections - the default should be adequate. Again this option is only
used if the poly is not rectangular.}
}

\details{
Function written by Mikala Jarner (2000). Modification of Julia Kelsall's
function kdeedge. This function uses a new external C-file (instead of Julia's
Fortran code) to perform the point-in-polygon test needed for calculating the
edge correction.
}

\seealso{kdespat}

\keyword{}
