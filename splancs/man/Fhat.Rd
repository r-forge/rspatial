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
A vector of the same length as \fCs}, containing the value of Fhat at the 
distances in \fCs}.


}
\section{METHOD}{
The function \fCFhat(pts1,pts2,s)} is defined as the proportion of members of a
point set \fCpts2} for which the distance to the nearest member of
another points set \fCpts1} is less than or equal to \fCs}.
}
\seealso{
\fCnndistF},\fCFzero}
}
% Converted by Sd2Rd version 0.3-3.
