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
If \fCout=T}, return the points outside the polygon, else the points inside.
}}
\value{
\fCpip} returns the points of \fCpts} that lie inside (or outside with
\fCout=T})
the polygon \fCpoly}. Compare this with \fCinpip}, which returns
the indices of
the points in the polygon, and \fCinout} which returns a logical vector
indicating whether points are inside or outside.


}
\section{METHOD}{
\fCpip} calls \fCinout}, then selects the appropriate sub-set of points.
}
\seealso{
\fCinpip},\fCinout}
}
\examples{
ptsin <- pip(pts,poly)   # gets the points in the poly
ptsout<- pip(pts,poly,out=T) # gets the points outside the poly
}
% Converted by Sd2Rd version 0.3-3.
