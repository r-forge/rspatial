\name{tolplot}

\alias{tolplot}


\title{Plot surface risk of matched case-control study}

\description{
'tolplot' simply subtracts the information needed from the output of
fitsmacc and tolsmacc and produces an image plot with 95\% tolerance
contours on. The range of the surface values are written as subtext. A
toptext is optional.  This function mainly sets things up nicely and then
calls the function plotrisk, so for more detailed information see this
function.
}

\usage{
tolplot(fitout, tolout, poly, toptext = "")
}

\arguments{
\item{fitout}{Output of a call to 'fitsmacc'.}
\item{tolout}{Output of a call to 'tolsmacc'.}
\item{poly}{Polygon that contains all the data.}
\item{toptext}{Text for the top of the plot.}
}

\examples{
}

\references{
}

\keyword{}
