\name{plotrisk}

\alias{plotrisk}

\title{Plot relative risks and tolreance contours.}

\description{
Plots an image of the given risk estimate with added tolerance contours on the
current graphics device. If pval=T an overall P-value for the hypothesis of
constant risk is displayed on the graph.
}


\usage{
plotrisk(risk, zlim, clevels = default, tolvals = c(0.025, 0.975),
                     toptitle = NA, pval = FALSE)
}


\arguments{
\item{risk}{A list of the form (x, y, z, est, poly) where (x,y) are the
spatial locations (probably in a regular grid), z is the matrix of
the proportion of simulated data sets below the observed value in
each point, est is the (x,y,z) values of the observed relative risk
surface calculated by the function relrisk and poly is a polygon which
contains the original points.}
\item{zlim}{The minimum and maximum level for the function image.}
\item{clevels}{The contour levels to be plotted.}
\item{tolvals}{The tolerance contours required - default is 95\%.}
\item{toptitle}{A title for the plot.}
\item{pval}{Logical value. If true the overall P-value is displayed on the plot.}
}

\seealso{relrisk}

\examples{
data(southlancs)

cases<-southlancs.pts[southlancs$cc==1,]
controls<-southlancs.pts[southlancs$cc==0,]
rr<-relrisk(cases, controls, southlancs.bdy, 1700, 1700, grid=TRUE, ngrid=1000)

plotrisk(list(x=rr$x, y=rr$y, z=rr$z, est=rr, poly=southlancs.bdy), 
   toptitle="Relative risk in South Lancashire")

}

\references{


}


\keyword{}
