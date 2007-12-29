\name{likcv}

\alias{likcv}

\title{Calculates the likelihood cross-validation criterion}


\description{
Calculates the likelihood cross-validation criterion for a given bandwidth h,
as defined in Kelsall and Diggle (1998) for a binary regression problem.
We automatically divide by the value of the L-CV obtained by using an
infinite smoothing parameter, such that all values are positive and
such that values below 1 indicate a non-constant spatial surface.

'minh' runs the function likcv on a vector of h values and singles out the one
that minimises the likelihood cross-validation criterion stated in
Kelsall&Diggle(1998). When doing density ratio estimation using the binary
regression approach.
}

\usage{
likcv(pts1, pts2, h, kernel = "normal")
minh(pts1, pts2, hvals, kernel = "normal", graph = TRUE)
}

\arguments{
\item{pts1}{A point dataset (the cases).}
\item{pts2}{A point dataset (the controls).}
\item{h}{A bandwidth parameter.}
\item{hvals}{A  vector of bandwidth parameters.}
\item{kernel}{Choice of kernel (either "normal" or "quartic").}
\item{graph}{If true the L-CV values are plotted against the h values on the
current graphics device.}
}

\seealso{
minh
}

\examples{

data(southlancs)

cases<-southlancs.pts[southlancs.cc==1,]
controls<-southlancs.pts[southlancs.cc==0,]
minh(cases, controls, seq(1000, 2000, by=50) )

}

\references{
Kelsall, J. E. and Diggle, P. J. (1998). Spatial variation in risk of disease: A nonparametric binary regression approach. Applied Statistics, 47(4):559-573.
}

\keyword{}
