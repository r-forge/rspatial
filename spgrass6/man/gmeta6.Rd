% Copyright (C) 2005 Roger S. Bivand
%
\name{gmeta6}
\alias{gmeta6}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Reads GRASS metadata from the current LOCATION}
\description{
  GRASS LOCATION metadata are read into a list in R.
}
\usage{
gmeta6()
}
%- maybe also 'usage' for other objects documented here.

\value{
  Returns list of g.gisenv, g.region -3, and g.proj values
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  G <- gmeta6()
  str(G)
}
}
\keyword{spatial}

