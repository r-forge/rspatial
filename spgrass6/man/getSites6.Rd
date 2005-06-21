% Copyright (C) 2005 Roger S. Bivand
%
\name{getSites6}
\alias{getSites6}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Import GRASS vector point sites file}
\description{
  \code{getSites6} moves one GRASS 6.0 vector point sites file to a data frame, returning the filled object.
}
\usage{
getSites6(vname)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A GRASS 6.0 vector point sites file}
}

\value{
  A data frame with at least cat, x, and y columns
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  bugs <- getSites6("bugsites")
  str(bugs)
}
}
\keyword{spatial}


