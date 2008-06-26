\name{spgrass6-package}
\alias{spgrass6-package}
\alias{spgrass6}
\docType{package}
\title{
Interface between GRASS 6.0 geographical information system and R
}
\description{
Interpreted interface between GRASS 6.0 geographical
information system and R, based on starting R from within the
GRASS environment. The interface uses classes defined in the sp package
to hold spatial data.
}

\details{
Index:
\preformatted{
readRAST6               read GRASS 6 raster files
writeRAST6              write GRASS 6 raster files
readVECT6               read GRASS 6 vector object files
writeVECT6              write GRASS 6 vector object files
gmeta6                  read GRASS metadata from the current LOCATION
getLocationProj         return a PROJ.4 string of projection information
gmeta2grd               create a GridTopology object from the GRASS region
vInfo                   return vector geometry information
vColumns                return vector database columns information
vDataCount              return count of vector database rows
vect2neigh              return area neighbours with shared boundary length
}
Further information may be found in the document \code{doc/spgrass_0.3.pdf} in the directory returned by \code{system.file("", package="spgrass6")}.
}
\author{
Roger Bivand

Maintainer: Roger Bivand <Roger.Bivand@nhh.no>

}

\keyword{ package }
\keyword{ spatial }


\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  soilsph <- readRAST6("soils.ph", ignore.stderr=TRUE, plugin=FALSE)
  summary(soilsph)
  grd <- gmeta2grd(ignore.stderr=TRUE)
  grd
  set.seed(1)
  smple <- overlay(soilsph, spsample(soilsph, 200, "random"))
  summary(smple)
  writeVECT6(smple, "sp_dem", v.in.ogr_flags="--overwrite", ignore.stderr=TRUE)
  bugsDF <- readVECT6("bugsites", ignore.stderr=TRUE, mapset="PERMANENT")
  summary(bugsDF)
  vInfo("streams", ignore.stderr=TRUE)
  vColumns("streams", ignore.stderr=TRUE)
  vDataCount("streams", ignore.stderr=TRUE)
  streams <- readVECT6("streams", type="line,boundary", remove.duplicates=FALSE, ignore.stderr=TRUE, plugin=FALSE)
  summary(streams)
}
}
