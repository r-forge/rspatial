\name{Fzero}
\alias{Fzero}
\title{
Point Summary Statistics
}
\description{
Calculate the theoretical nearest neighbour distribution function.
}
\usage{
Fzero(density,s)
}
\arguments{
\item{density}{
The density of the point pattern, i.e. the number of points per unit area.
}
\item{s}{
A vector of distances at which to evaluate Fzero
}}
\value{
A vector of the same length as \code{s}, containing the value of Fzero at the 
distances in \code{s}.


}
\section{METHOD}{
Fzero returns the nearest neighbour distribution for a homogeneous planar
Poisson process. In fortran notation, Fzero(s) is
\code{FZERO = 1-EXP(-PI*DENSITY*(S**2))}.
}
\seealso{
\code{Fhat},\code{Ghat},\code{pdense}
}
% Converted by Sd2Rd version 0.3-3.
