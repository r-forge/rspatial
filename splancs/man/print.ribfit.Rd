\name{print.ribfit}
\alias{print.ribfit}
\title{
Raised Incidence Modelling
}
\description{
Display the fit from \fCtribble}
}
\usage{
print.ribfit(fitobj)
}
\arguments{
\item{fitobj}{
An object returned from \fCtribble}
}}
\section{Side Effects}{
 The parameter estimates and log-likelihood for the raised incidence 
model are displayed. The likelihood ratio, D = 2*(L-Lo), is also given.
}
\details{
 This function is called whenever \fCprint} operates on an object
with class \fCribfit}.
}
\seealso{
tribble
}
% Converted by Sd2Rd version 0.3-3.
