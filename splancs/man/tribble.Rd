\name{tribble}
\alias{tribble}
\title{
Diggle-Rowlingson Raised Incidence Model
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
A matrix where \code{vars[i,j]} is the distance squared from point \code{i} 
to source \code{j}.
}
\item{alphas}{
Initial value of the \code{alpha} parameters.
}
\item{betas}{
Initial value of the \code{beta} parameters.
}
\item{rho}{
Initial value of the \code{rho} parameter.
}
\item{which}{
Defines the mapping from sources to parameters.
}
\item{covars}{
A matrix of covariates to be modelled as log-linear terms. The element 
\code{covars[i,j]} is the value of covariate \code{j} for case/control \code{i}.
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
The return value is a list with many components, and class \code{ribfit}. 
\(bu \code{$alphas} A vector of the alpha parameters at the maximum
\(bu \code{$betas} A vector of the beta values at the maximum
\(bu \code{$rho} The value of rho at the maximum
\(bu \code{$logl} The maximised log-likelihood
\(bu \code{$null.logl} The null log-likelihood
\(bu \code{$call} The function call to \code{tribble}
For further information see Diggle and Rowlingson (1993).
}
\seealso{
triblik, dsquare
}
% Converted by Sd2Rd version 0.3-3.
