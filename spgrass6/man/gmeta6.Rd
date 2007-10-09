% Copyright (C) 2005 Roger S. Bivand
%
\name{gmeta6}
\alias{gmeta6}
\alias{getLocationProj}
\alias{gmeta2grd}
\alias{print.gmeta6}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Reads GRASS metadata from the current LOCATION}
\description{
  GRASS LOCATION metadata are read into a list in R; helper function getLocationProj returns an spproj-compliant PROJ.4 string of projection information. The helper function \code{gmeta2grd} creates a GridTopology object from the current GRASS mapset region definitions.
}
\usage{
gmeta6(ignore.stderr = FALSE)
getLocationProj(ignore.stderr = FALSE)
gmeta2grd(ignore.stderr = FALSE)
\method{print}{gmeta6}(x, ...)
}
\arguments{
  \item{ignore.stderr}{default FALSE, can be set to TRUE to silence \code{system()} output to standard error; does not apply on Windows platforms}
  \item{x}{S3 object returned by gmeta6}
  \item{...}{arguments passed through print method}
}
%- maybe also 'usage' for other objects documented here.

\value{
  Returns list of g.gisenv, g.region -g3, and g.proj values
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  G <- gmeta6()
  print(G)
  CRS(getLocationProj())
  grd <- gmeta2grd()
  print(grd)
  ncells <- prod(slot(grd, "cells.dim"))
  df <- data.frame(k=rep(1, ncells))
  mask_SG <- SpatialGridDataFrame(grd, data=df)
  summary(mask_SG)
}
}
\keyword{spatial}

