\name{Kenv.tor}
\alias{Kenv.tor}
\title{
Simulations
}
\description{
Compute envelope of K12hat from random toroidal shifts of two point patterns.
}
\usage{
Kenv.tor(pts1,pts2,poly,ntor,s,quiet=F)
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
\item{ntor}{
Number of random toroidal shifts to do.
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
The second point data set is randomly shifted using \fCrtor.shift}
in the rectangle defined by \fCpoly}. Then \fCk12hat} is called 
to compute K12hat for the two patterns. 
The upper and lower values of K12hat over the \fCntor}
toroidal shifts are returned.


}
\seealso{
\fCrtor.shift},\fCk12hat}
}
% Converted by Sd2Rd version 0.3-3.
