\name{Kenv.label}
\alias{Kenv.label}
\title{
Simulations
}
\description{
Compute envelope of K1hat-K2hat from random labelling of two point patterns
}
\usage{
Kenv.label(pts1,pts2,poly,nlab,s,quiet=F)
}
\arguments{
\item{pts1}{
First point data set.
}
\item{pts2}{
Second point data set.
}
\item{poly}{
Polygon containing the points.
}
\item{nlab}{
Number of random labellings to do.
}
\item{s}{
Vector of distances at which to calculate the envelope.
}
\item{quiet}{
If false, print a message after every simulation for progress monitoring. If
true, print no messages.
}}
\value{
A list with two components, called \fC$upper} and \fC$lower}. Each
component is a vector like \fCs}.
}
\section{METHOD}{
The two point data sets are randomly labelled using \fCrlabel}, then
\fCKhat} is called to estimate the K-function for each resulting set
at the distances in \fCs}. The difference between these two estimates
is then calculated. 
The maximum and minimum values of this difference at each distance,over
the \fCnlab}
labellings is returned.


}
\seealso{
\fCrlabel},\fCkhat}
}
% Converted by Sd2Rd version 0.3-3.
