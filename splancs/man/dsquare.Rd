\name{dsquare}
\alias{dsquare}
\title{
Raised Incidence Modelling
}
\description{
Computes the distance-squared from a number of points to a number of sources.
}
\usage{
dsquare(pts, srcs, namepref="d")
}
\arguments{
\item{pts}{
A number of points representing the locations of cases and controls.
}
\item{srcs}{
A number of points representing source locations
}
\item{namepref}{
A prefix given to the name of the results.
}}
\value{
A data frame with the same number of  columns as \fCsrcs}. The column names will 
be the value of \fCnamepref} prefixing the numbers from 1 to the number
of sources.
}
\seealso{
tribble, triblik


}
% Converted by Sd2Rd version 0.3-3.
