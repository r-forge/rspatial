\name{triblik}
\alias{triblik}
\title{
Raised Incidence Modelling
}
\description{
Calculates the log-likelihood for the Diggle-Rowlingson raised incidence model.
}
\usage{
triblik(ccflag, vars=NULL, alphas=NULL, betas=NULL, rho, 
+ which=1:length(alphas), covars=NULL, thetas=NULL)
}
\arguments{
\item{ccflag}{
Case-control flag : a vector of ones and zeroes.
}
\item{vars}{
A matrix where \fCvars[i,j]} is the distance squared from point \fCi} 
to source \fCj}.
}
\item{alphas}{
The \fCalpha} parameters.
}
\item{betas}{
The \fCbeta} parameters.
}
\item{rho}{
The \fCrho} parameter.
}
\item{which}{
Defines the mapping from sources to parameters.
}
\item{covars}{
A matrix of covariates to be modelled as log-linear terms. The element 
\fCcovars[i,j]} is the value of covariate \fCj} for case/control \fCi}.
}
\item{thetas}{
The covariate parameters.
}}
\value{
The log-likelihood for the given parameters and the given distances and
optional covariates is returned.
}
\seealso{
tribble, dsquare
}
% Converted by Sd2Rd version 0.3-3.
