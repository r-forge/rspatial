\name{pip}
\alias{pip}
\title{
Point/Poly Operations
}
\description{
Return points inside or outside a polygon.
}
\usage{
pip(pts,poly,out=F)
}
\arguments{
\item{pts}{
A points data set
}
\item{poly}{
A polygon data set
}
\item{out}{
If \code{out=T}, return the points outside the polygon, else the points inside.
}}
\value{
\code{pip} returns the points of \code{pts} that lie inside (or outside with
\code{out=T})
the polygon \code{poly}. Compare this with \code{inpip}, which returns
the indices of
the points in the polygon, and \code{inout} which returns a logical vector
indicating whether points are inside or outside.


}
\section{METHOD}{
\code{pip} calls \code{inout}, then selects the appropriate sub-set of points.
}
\seealso{
\code{inpip},\code{inout}
}
\examples{
ptsin <- pip(pts,poly)   # gets the points in the poly
ptsout<- pip(pts,poly,out=T) # gets the points outside the poly
}
% Converted by Sd2Rd version 0.3-3.
