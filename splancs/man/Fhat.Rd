\name{Fhat}
\alias{Fhat}
\title{
Point Summary Statistics
}
\description{
Calculates an estimate of the F nearest neighbour distribution function
}
\usage{
Fhat(pts1,pts2,s)
}
\arguments{
\item{pts1}{
A points data set
}
\item{pts2}{
A points data set
}
\item{s}{
A vector of distances at which to evaluate Fhat
}}
\value{
A vector of the same length as \code{s}, containing the value of Fhat at the 
distances in \code{s}.


}
\section{METHOD}{
The function \code{Fhat(pts1,pts2,s)} is defined as the proportion of members of a
point set \code{pts2} for which the distance to the nearest member of
another points set \code{pts1} is less than or equal to \code{s}.
}
\seealso{
\code{nndistF},\code{Fzero}
}
% Converted by Sd2Rd version 0.3-3.
