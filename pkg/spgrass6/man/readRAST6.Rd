% Copyright (C) 2005-2011 Roger S. Bivand
%
\name{readRAST6}
\alias{readRAST6}
%\alias{readBinGrid}
\alias{writeRAST6}
%\alias{writeBinGrid}
%\alias{rast.get6}
%\alias{rast.put6}
%\alias{readCELL6sp}
%\alias{readFLOAT6sp}
%\alias{writeRast6sp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read and write GRASS 6+ raster files}
\description{
Read GRASS 6+ raster files from GRASS 6+ into R SpatialGridDataFrame objects, and write single columns of R SpatialGridDataFrame objects to GRASS 6+. \code{readRAST6} and \code{writeRAST6} use temporary binary files and r.out.bin and r.in.bin rather than the temporary ASCII files used in earlier implementations. The earlier versions may still be used in a transition period. 
}



\usage{
readRAST6(vname, cat=NULL, ignore.stderr = NULL, NODATA=NULL, plugin=NULL, mapset=NULL, useGDAL=NULL, close_OK=TRUE, drivername="GTiff")
writeRAST6(x, vname, zcol = 1, NODATA=NULL, ignore.stderr = NULL, useGDAL=NULL, overwrite=FALSE, flags=NULL, drivername="GTiff")
%rast.get6(vname, cat=NULL, ignore.stderr = FALSE)
%rast.put6(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE)
%readCELL6sp(vname, cat=NULL, ignore.stderr = FALSE)
%readFLOAT6sp(vname, ignore.stderr = FALSE)
%writeRast6sp(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE)
%readBinGrid(fname, colname=basename(fname), proj4string=CRS(as.character(NA)), integer)
%writeBinGrid(x, fname, attr = 1, na.value = -9999)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A vector of GRASS 6.0 raster file names}
%  \item{fname}{file name}
%  \item{proj4string}{A CRS object setting the projection arguments of the Spatial Grid returned}
  \item{cat}{default NULL; if not NULL, must be a logical vector matching vname, stating which (CELL) rasters to return as factor}
  \item{ignore.stderr}{default NULL, taking the value set by \code{set.ignore.stderrOption}, can be set to TRUE to silence \code{system()} output to standard error; does not apply on Windows platforms}
  \item{plugin}{default NULL does auto-detection, changes to FALSE if vname is longer than 1, and a sanity check will be run on raster and current region, and the function will revert to FALSE if mismatch is found; if TRUE, the plugin is available and the raster should be read in its original region and resolution; if the plugin is used, no further arguments other than mapset are respected}
  \item{mapset}{default NULL, if plugin is TRUE, the mapset of the file to be imported will be autodetected; if not NULL and if plugin is TRUE, a character string overriding the autodetected mapset, otherwise ignored}
  \item{useGDAL}{default NULL, taking the value set by \code{set.useGDALOption}; use r.out.gdal or plugin and \code{readGDAL} if autodetected or plugin=TRUE; or for writing \code{writeGDAL}, GTiff, and r.in.gdal, if FALSE using r.out.bin or r.in.bin}
  \item{close_OK}{default TRUE - clean up possible open connections used for reading metadata; may be set to FALSE to avoid the side-effect of other user-opened connections being broken}
  \item{drivername}{default \code{"GTiff"}; a valid GDAL writable driver name to define the file format for intermediate files}
  \item{x}{A SpatialGridDataFrame object for export to GRASS as a raster layer}
  \item{zcol}{Attribute column number or name}
  \item{NODATA}{by default NULL, in which case it is set to one less than \code{floor()}of the data values, otherwise an integer NODATA value (required to be integer by GRASS r.out.bin)}
  \item{overwrite}{default FALSE, if TRUE inserts \code{"overwrite"} into the value of the \code{flags} argument if not already there to allow existing GRASS rasters to be overwritten}
  \item{flags}{default NULL, character vector, for example \code{"overwrite"}}
%  \item{colname}{alternative name for data column if not file basename}
%  \item{integer}{logical value: TRUE if the input data is integer}
}

\value{
\code{readRAST6} returns a SpatialGridDataFrame objects with an data.frame in the data slots, and with the projection argument set. Note that the projection argument set is the the GRASS rendering of proj4, and will differ from the WKT/ESRI rendering returned by readVECT6 in form but not meaning. They are exchangeable but not textually identical, usually with the +ellps= term replaced by ellipsoid parameters verbatim.
}


\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  require(rgdal)
  ois <- get.ignore.stderrOption()
  set.ignore.stderrOption(TRUE)
  get.useGDALOption()
  spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE),
    plugin=NULL)
  spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE),
    useGDAL=FALSE, plugin=FALSE)
  spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE),
    useGDAL=TRUE, plugin=FALSE)
  print(table(spear$geology))
  execGRASS("r.stats", flags=c("c", "l", "quiet"), input="geology")
  boxplot(spear$elevation.dem ~ spear$geology)
  spear$sqdem <- sqrt(spear$elevation.dem)
  if ("GRASS" \%in\% gdalDrivers()$name) {
    dem1 <- readRAST6("elevation.dem", plugin=TRUE, mapset="PERMANENT")
    print(summary(dem1))
  }
  writeRAST6(spear, "sqdemSP", zcol="sqdem")
  execGRASS("r.info", map="sqdemSP")
  execGRASS("g.remove", rast="sqdemSP")
  writeRAST6(spear, "sqdemSP", zcol="sqdem", useGDAL=TRUE)
  execGRASS("r.info", map="sqdemSP")
  execGRASS("g.remove", rast="sqdemSP")
  if (execGRASS("g.version", intern=TRUE) > "GRASS 7") {
    execGRASS("r.mapcalc", expression="quads0 = quads - 1")
  } else {
    execGRASS("r.mapcalculator", outfile="quads0",
      amap="quads", formula='A - 1')
  }
  execGRASS("r.stats", flags="c", input="quads0")
  quads0 <- readRAST6("quads0")
  print(table(quads0$quads0))
  quads0 <- readRAST6("quads0", plugin=FALSE)
  print(table(quads0$quads0))
  execGRASS("g.remove", rast="quads0")
  set.ignore.stderrOption(ois)
}
}
\keyword{spatial}

