\name{cvkernratio}
\alias{cvkernratio}

\title{Estimate optimal bandwidth for a case-control point pattern using
a cross-validation criterion.}

\description{
'cvkernratio' computes the criterion described in Kelsall and Diggle (1995)
to estimate the best bandwith value for a case-control point pattern.
The integral involved in the criterion is computed using 'adapt'.
}

\usage{
cvkernratio(ccpts, ncases, ncontrols, pbdry, h, kernel="normal", edge=TRUE)
}

\arguments{
\item{ccpts}{A point data set with cases followed by the controls.}
\item{ncases}{Number of cases in ccpts.}
\item{ncontrols}{Number of controls in ccpts (after the cases).}
\item{pbdry}{Boundary that contains all the observed points.}
\item{h}{A vector with bandwidth values where the criterion is computed.}
\item{kernel}{Kernel estimator. Either "normal" or "quartic".}
\item{edge}{Boolean - whether edge correction is used or not.}
}

\examples{
data(southlancs)

ncases<-sum(southlancs.cc==1)
ncontrols<-sum(southlancs.cc==0)
ccpts<-southlancs.pts[nrow(southlancs.pts):1,]
h<-seq(1600, 1800, by=50)

cvres<-cvkernratio(ccpts, ncases, ncontrols, southlancs.bdy, 
   h=h, kernel="normal", edge=FALSE)

plot(cvres$h, cvres$cv, main="Bandwidth selection criterion")

}

\references{
}

\keyword{}
