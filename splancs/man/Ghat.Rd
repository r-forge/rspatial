\name{Ghat}
\alias{Ghat}
\title{
Point Summary Statistics
}
\description{
Calculates an estimate of the G nearest neighbour distribution function.
}
\usage{
Ghat(points,s)
}
\arguments{
\item{points}{
A points data set
}
\item{s}{
A vector of distances at which to evaluate the G function
}}
\value{
A vector of the same length as \code{s}, containing the estimate of G at the 
distances in \code{s}.


}
\section{METHOD}{
The function \code{Ghat(points,s)} is defined as the proportion of members of a
point set for which the distance to the nearest other member of the set
is less than or equal to \code{s}.
}
% Converted by Sd2Rd version 0.3-3.
