% Copyright (C) 2005 Roger S. Bivand
%
\name{putSites6sp}
\alias{putSites6sp}
\alias{getSites6sp}
\alias{putSites6}
\alias{getSites6}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Export GRASS vector point sites file}
\description{
  \code{getSites6sp} moves one GRASS 6.0 vector point sites file with attribute data through a temporary shapefile to a SpatialPointsDataFrame object; \code{putSites6sp} moves a SpatialPointsDataFrame object through a temporary shapefile to a GRASS vector point sites file.
}
\usage{
putSites6sp(SPDF, vname, factor2char = TRUE) 
putSites6(df, vname)
getSites6sp(vname) 
getSites6(vname)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SPDF}{A SpatialPointsDataFrame to be moved to GRASS6 as vector points}
  \item{vname}{A GRASS 6.0 vector point sites file name (must not exist already)}
  \item{factor2char}{logical, default TRUE, convert factor columns to character
}
  \item{df}{A data frame with at least columns named x, y and cat (no z support yet)}
}
\value{
  getSites6sp() imports a GRASS6 vector points object into a SpatialPointsDataFrame object; getSites6() returns a data frame.
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  system("v.info bugsites")
  bugs <- getSites6("bugsites")
  names(bugs)[3:4] <- c("x", "y")
  str(bugs)
  putSites6(bugs, "newbugs")
  system("v.info newbugs")
  system("g.remove vect=newbugs")
  system("v.info bugsites")
  bugs <- getSites6sp("bugsites")
  summary(bugs)
  putSites6sp(bugs, "newbugs")
  system("v.info newbugs")
  system("g.remove vect=newbugs")
}
}
\keyword{spatial}

