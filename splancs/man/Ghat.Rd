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
A vector of the same length as \fCs}, containing the estimate of G at the 
distances in \fCs}.


}
\section{METHOD}{
The function \fCGhat(points,s)} is defined as the proportion of members of a
point set for which the distance to the nearest other member of the set
is less than or equal to \fCs}.
}
% Converted by Sd2Rd version 0.3-3.
