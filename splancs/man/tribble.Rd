% Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
% Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
% R port: copyright 1998-2000 by Roger S. Bivand
%
%  This program is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation; either version 2 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%

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
\item \code{$alphas} A vector of the alpha parameters at the maximum
\item \code{$betas} A vector of the beta values at the maximum
\item \code{$rho} The value of rho at the maximum
\item \code{$logl} The maximised log-likelihood
\item \code{$null.logl} The null log-likelihood
\item \code{$call} The function call to \code{tribble}
For further information see Diggle and Rowlingson (1993).
}
\seealso{
triblik, dsquare
}

\references{
Rowlingson, B. and Diggle, P. 1993 Splancs: spatial point pattern analysis
code in S-Plus.  Computers and Geosciences, 19, 627-655, (Barry Rowlingson
<b.rowlingson@lancaster.ac.uk>); the original sources can be accessed at:
http://www.maths.lancs.ac.uk/~rowlings/Splancs/. See also Bivand, R. and
Gebhardt, A. 2000 Implementing functions for spatial statistical analysis
using the R language. Journal of Geographical Systems, 2, 307-317.
}

% Converted by Sd2Rd version 0.3-3.
\keyword{spatial}

