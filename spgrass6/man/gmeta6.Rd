% Copyright (C) 2005 Roger S. Bivand
%
\name{gmeta6}
\alias{gmeta6}
\alias{getLocationProj}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Reads GRASS metadata from the current LOCATION}
\description{
  GRASS LOCATION metadata are read into a list in R; helper function getLocationProj returns an spproj-compliant PROJ.4 string of projection information.
}
\usage{
gmeta6(ignore.stderr = FALSE)
getLocationProj(ignore.stderr = FALSE)
}
\arguments{
  \item{ignore.stderr}{default FALSE, can be set to TRUE to silence \code{system()} output to standard error}
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
  getLocationProj()
  CRS(getLocationProj())
}
}
\keyword{spatial}

