% Copyright (C) 2005 Roger S. Bivand
%
\name{putSites6}
\alias{putSites6}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Export GRASS vector point sites file}
\description{
  \code{putSites6} moves a data frame to a GRASS vector point sites list.
}
\usage{
putSites6(df, vname)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{df}{A data frame with at least columns named x, y and cat (no z support yet)}
  \item{vname}{A GRASS 6.0 vector point sites file name (must not exist already)}
}

\value{
  returns the command string for v.in.ascii
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  bugs <- getSites6("bugsites")
  str(bugs)
  putSites6(bugs, "newbugs")
}
}
\keyword{spatial}

