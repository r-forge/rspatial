\name{tribble}
\alias{tribble}
\title{
Raised Incidence Modelling
}
\description{
Fits the Diggle-Rowlingson Raised Incidence Model.
}
\usage{
tribble(ccflag, vars=NULL, alphas=NULL, betas=NULL, rho, 
+ which=1:length(alphas), covars=NULL, thetas=NULL, 
+ steps=NULL, reqmin=0.001, icount=50, hessian=NULL)
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
Initial value of the \fCalpha} parameters.
}
\item{betas}{
Initial value of the \fCbeta} parameters.
}
\item{rho}{
Initial value of the \fCrho} parameter.
}
\item{which}{
Defines the mapping from sources to parameters.
}
\item{covars}{
A matrix of covariates to be modelled as log-linear terms. The element 
\fCcovars[i,j]} is the value of covariate \fCj} for case/control \fCi}.
}
\item{thetas}{
Initial values of covariate parameters.
}
\item{steps}{
Step sizes for the Nelder-Mead simplex algorithm.
}
\item{reqmin}{
Tolerance for simplex algorithm
}
\item{icount}{
Iteration count for simplex algorithm
}}
\value{
The return value is a list with many components, and class \fCribfit}. 
\(bu \fC$alphas} A vector of the alpha parameters at the maximum
\(bu \fC$betas} A vector of the beta values at the maximum
\(bu \fC$rho} The value of rho at the maximum
\(bu \fC$logl} The maximised log-likelihood
\(bu \fC$null.logl} The null log-likelihood
\(bu \fC$call} The function call to \fCtribble}
For further information see Diggle and Rowlingson (1993).
}
\seealso{
triblik, dsquare
}
% Converted by Sd2Rd version 0.3-3.
