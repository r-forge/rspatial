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

\name{triblik}
\alias{triblik}
\title{
Log-likelihood for the Diggle-Rowlingson raised incidence model
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
A matrix where \code{vars[i,j]} is the distance squared from point \code{i} 
to source \code{j}.
}
\item{alphas}{
The \code{alpha} parameters.
}
\item{betas}{
The \code{beta} parameters.
}
\item{rho}{
The \code{rho} parameter.
}
\item{which}{
Defines the mapping from sources to parameters.
}
\item{covars}{
A matrix of covariates to be modelled as log-linear terms. The element 
\code{covars[i,j]} is the value of covariate \code{j} for case/control \code{i}.
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
