\name{print.ribfit}
\alias{print.ribfit}
\title{
Display the fit from \code{tribble}
}
\description{
Display the fit from \code{tribble}
}
\usage{
print.ribfit(fitobj)
}
\arguments{
\item{fitobj}{
An object returned from \code{tribble}
}}
\section{Side Effects}{
 The parameter estimates and log-likelihood for the raised incidence 
model are displayed. The likelihood ratio, D = 2*(L-Lo), is also given.
}
\details{
 This function is called whenever \code{print} operates on an object
with class \code{ribfit}.
}
\seealso{
tribble
}
% Converted by Sd2Rd version 0.3-3.
