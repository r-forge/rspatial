% Copyright (C) 2005-6 Roger S. Bivand
%
\name{readVECT6}
\alias{readVECT6}
\alias{writeVECT6}
\alias{vInfo}
\alias{vColumns}
\alias{vDataCount}
\alias{vect2neigh}
\alias{putSites6sp}
\alias{getSites6sp}
\alias{putSites6}
\alias{getSites6}
\alias{cygwin_clean_temp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read and write GRASS 6 vector object files}
\description{
  \code{readVECT6} moves one GRASS 6.0 vector object file with attribute data through a temporary shapefile to a Spatial*DataFrame object of type determined by the GRASS 6.0 vector object; \code{writeVECT6} moves a Spatial*DataFrame object through a temporary shapefile to a GRASS vector object file. \code{vect2neigh} returns neighbour pairs with shared boundary length as described by Markus Neteler, in \url{https://stat.ethz.ch/pipermail/r-sig-geo/2005-October/000616.html}. \code{cygwin_clean_temp} can be called to try to clean the GRASS mapset-specific temporary directory under cygwin.
}
\usage{
readVECT6(vname, type=NULL, plugin=FALSE, remove.duplicates = TRUE, ignore.stderr = FALSE, with_prj=TRUE, with_c=FALSE, mapset=NULL)
writeVECT6(SDF, vname,  v.in.ogr_flags="", ignore.stderr = FALSE)
vInfo(vname, ignore.stderr = FALSE)
vColumns(vname, ignore.stderr = TRUE)
vDataCount(vname, ignore.stderr = TRUE)
vect2neigh(vname, ID=NULL, ignore.stderr = FALSE)
putSites6sp(SPDF, vname,  ignore.stderr = FALSE) 
putSites6(df, vname, ignore.stderr = FALSE)
getSites6sp(vname, ignore.stderr = FALSE, with_prj=TRUE) 
getSites6(vname, ignore.stderr = FALSE, with_prj=TRUE)
cygwin_clean_temp(verbose=TRUE, ignore.stderr = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A GRASS 6.0 vector file name}
  \item{type}{override type detection when multiple types are non-zero, passed to v.out.ogr}
  \item{plugin}{default FALSE, should be set to NULL for auto-detection, and TRUE if the plugin is available; if the plugin is used, no further arguments other than mapset are respected}
  \item{remove.duplicates}{In line and area vector objects, multiple geometrical features may be associated with a single cat number, leading to duplication of data rows; this argument attempts to combine the geometrical features so that they match a single data row}
  \item{ignore.stderr}{default FALSE, can be set to TRUE to silence \code{system} output to standard error; does not apply on Windows platforms}
  \item{with_prj}{default TRUE, write ESRI-style PRJ file for transfered data}
  \item{with_c}{if TRUE, export features with category (labeled) only; by default all features are exported}
  \item{mapset}{if plugin is TRUE, the mapset of the file to be imported may be changed from the current mapset by passing a character string}
  \item{SDF}{A Spatial*DataFrame to be moved to GRASS6 as a vector object, for SpatialPointsDataFrame, SpatialLinesDataFrame, and SpatialPolygonsDataFrame objects}
  \item{v.in.ogr_flags}{String containing additional optional flags and/or options for v.in.ogr, particularly -o and --overwrite}
  \item{ID}{A valid DB column name for unique identifiers (optional)}
  \item{SPDF}{A SpatialPointsDataFrame to be moved to GRASS6 as vector points}
  \item{df}{A data frame with at least columns named x, y and cat (no z support yet)}
  \item{verbose}{TRUE, can be set to false}
}
\value{
   \code{readVECT6} imports a GRASS6 vector object into a Spatial*DataFrame object with the type determined by the type of the GRASS6 vector object; \code{getSites6} returns a data frame. \code{vect2neigh} returns a data frame object with left and right neighbours and boundary lengths, also given class GRASSneigh and spatial.neighbour (as used in spdep). The incantation to retrieve the neighbours list is \code{sn2listw(vect2neigh())$neighbours}, and to retrieve the boundary lengths: \code{sn2listw(vect2neigh())$weights}. The GRASSneigh object has two other useful attributes: external is a vector giving the length of shared boundary between each polygon and the external area, and total giving each polygon's total boundary length.
}
\note{
Please note that the OGR drivers used may not handle missing data gracefully, and be prepared to have to correct for this manually. For example use of the \code{\link[rgdal]{readOGR}} PostGIS driver directly may perform better than moving the data through the DBF driver used in this function - or a PostgreSQL driver used directly or through ODBC may be a solution. Do not rely on missing values of vector data moving smoothly across the interface.

Please also note that, on Windows and Cygwin systems, the temporary shapefiles are not removed by the interface functions, nor can GRASS remove them on termination - they must for the time being be removed manually. Windows believes that the GDAL/OGR library is still using them.

Instructions for installing the GDAL-GRASS plugin are to be found at \url{http://grass.osgeo.org/wiki/Compile_and_install_GRASS_and_QGIS_with_GDAL/OGR_Plugin}.
}
\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  if (Sys.getenv("OSTYPE") == "msys" || nchar(Sys.getenv("WINGISRC")) > 0)
    system("v.info.exe bugsites")
  else system("v.info bugsites")
  print(vInfo("bugsites", ignore.stderr=TRUE))
  bugs <- readVECT6("bugsites", ignore.stderr=TRUE)
  print(summary(bugs))
  if ("GRASS" \%in\% ogrDrivers()$name) {
    bugs1 <- readVECT6("bugsites", plugin=TRUE, ignore.stderr=TRUE,
      mapset="PERMANENT")
    print(summary(bugs1))
  }
  writeVECT6(bugs, "newbugs", v.in.ogr_flags="-o --overwrite", ignore.stderr=TRUE)
  if (Sys.getenv("OSTYPE") == "msys" || nchar(Sys.getenv("WINGISRC")) > 0)
    system("v.info.exe newbugs")
  else system("v.info newbugs")
  nbugs <- readVECT6("newbugs", ignore.stderr=TRUE)
  print(summary(nbugs))
  print(vInfo("streams", ignore.stderr=TRUE))
  streams <- readVECT6("streams", type="line,boundary", remove.duplicates=FALSE, ignore.stderr=TRUE)
  print(summary(streams))
}
}
\keyword{spatial}

