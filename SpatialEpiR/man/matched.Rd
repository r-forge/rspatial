\name{Edhat}

\alias{Edhat}
\alias{Vdhat}

\title{Difference of the K-function for matched cases and controls}

\description{
'Edhat' computes the expectation of K11-hat minus K22-hat for a matched
case-control dataset is calculated. For details see (Chetwynd et al.,
2001).

'Vdhat' computes the variance of K11-hat minus K22-hat for a matched
case-control dataset with tuplesizes 2 or 3 is calculated. A general
expression for an arbitrary number of controls per case is stated in
(Chetwynd et al., 2001) but has not been implemented.
}

\usage{
Edhat(pts1, pts2, poly, s, k)
Vdhat(pts1, pts2, poly, s, k)
}


\arguments{
\item{pts1}{A point dataset containing the cases.}
\item{pts2}{A point dataset containing the matched controls. The first n
rows should contain the first set of controls while the next n rows should
contain the second set of controls and so on.}
\item{poly}{A polygon containing all the points.}
\item{s}{A vector of distances for which the K-functions are evaluated.}
\item{k}{The number of events in a tuple, ie. k-1 is the number of matched
controls per case.}
}

\examples{

}

\references{
Chetwynd,A.G., Diggle,P.J.,  Marshall,A. and Parslow, R. (2001).
Investigations of spatial clustering from individually matched
case-control studies. Biostatistics, 2:277-293.
}

\keyword{}
