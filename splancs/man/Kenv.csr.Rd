\name{Kenv.csr}
\alias{Kenv.csr}
\title{
Simulations
}
\description{
Compute envelope of Khat from simulations of complete spatial randomness.
}
\usage{
Kenv.csr(nptg,poly,nsim,s,quiet=F)
}
\arguments{
\item{nptg}{
Number of points to generate in each simulation.
}
\item{poly}{
Polygon in which to generate the points.
}
\item{nsim}{
Number of simulations to do.
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
component is a vector like \fCs}. The two components contain the upper 
and lower bound of the Khat envelope. 


}
\seealso{
\fCcsr},\fCkhat}
}
% Converted by Sd2Rd version 0.3-3.
