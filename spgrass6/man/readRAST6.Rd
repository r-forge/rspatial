% Copyright (C) 2005-8 Roger S. Bivand
%
\name{readRAST6}
\alias{readRAST6}
\alias{readBinGrid}
\alias{writeRAST6}
\alias{writeBinGrid}
\alias{rast.get6}
\alias{rast.put6}
\alias{readCELL6sp}
\alias{readFLOAT6sp}
\alias{writeRast6sp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read and write GRASS 6 raster files}
\description{
Read GRASS 6 raster files from GRASS 6 into R SpatialGridDataFrame objects, and write single columns of R SpatialGridDataFrame objects to GRASS 6. \code{readRAST6} and \code{writeRAST6} use temporary binary files and r.out.bin and r.in.bin rather than the temporary ASCII files used in earlier implementations. The earlier versions may still be used in a transition period. 
}



\usage{
readRAST6(vname, cat=NULL, ignore.stderr = FALSE, NODATA=NULL, plugin=NULL, mapset=NULL, useGDAL=TRUE)
writeRAST6(x, vname, zcol = 1, NODATA=NULL, ignore.stderr = FALSE, useGDAL=TRUE, overwrite=FALSE)
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
  \item{ignore.stderr}{default FALSE, can be set to TRUE to silence \code{system()} output to standard error; does not apply on Windows platforms}
  \item{plugin}{default NULL does auto-detection, changes to FALSE if vname is longer than 1, and a sanity check will be run on raster and current region, and the function will revert to FALSE if mismatch is found; if TRUE, the plugin is available and the raster should be read in its original region and resolution; if the plugin is used, no further arguments other than mapset are respected}
  \item{mapset}{default NULL, if plugin is TRUE, the mapset of the file to be imported will be autodetected; if not NULL and if plugin is TRUE, a character string overriding the autodetected mapset, otherwise ignored}
  \item{useGDAL}{default TRUE use r.out.gdal or plugin and \code{readGDAL} if autodetected or plugin=TRUE; or for writing \code{writeGDAL}, GTiff, and r.in.gdal, if FALSE using r.out.bin or r.in.bin}
  \item{x}{A SpatialGridDataFrame object for export to GRASS as a raster layer}
  \item{zcol}{Attribute column number or name}
  \item{NODATA}{by default NULL, in which case it is set to one less than \code{floor()}of the data values, otherwise an integer NODATA value (required to be integer by GRASS r.out.bin)}
  \item{overwrite}{default FALSE, if TRUE inserts \code{--overwrite} to allow existing GRASS rasters to be overwritten}
%  \item{colname}{alternative name for data column if not file basename}
%  \item{integer}{logical value: TRUE if the input data is integer}
}

\value{
\code{readRAST6} returns a SpatialGridDataFrame objects with an data.frame in the data slots, and with the projection argument set. Note that the projection argument set is the the GRASS rendering of proj4, and will differ from the WKT/ESRI rendering returned by readVECT6 in form but not meaning. They are exchangeable but not textually identical, usually with the +ellps= term replaced by ellipsoid parameters verbatim.
}


\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE),
    ignore.stderr=TRUE, plugin=NULL)
  spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE),
    ignore.stderr=TRUE, useGDAL=FALSE, plugin=FALSE)
  spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE),
    ignore.stderr=TRUE, useGDAL=TRUE, plugin=FALSE)
  print(table(spear$geology))
  execGRASS("r.stats", flags=c("c", "l", "quiet"), 
    parameters=list(input="geology"), ignore.stderr=TRUE)
  boxplot(spear$elevation.dem ~ spear$geology)
  spear$sqdem <- sqrt(spear$elevation.dem)
  if ("GRASS" \%in\% gdalDrivers()$name) {
    dem1 <- readRAST6("elevation.dem", plugin=TRUE, ignore.stderr=TRUE,
      mapset="PERMANENT")
    print(summary(dem1))
  }
  writeRAST6(spear, "sqdemSP", zcol="sqdem", ignore.stderr=TRUE)
  execGRASS("r.info", parameters=list(map="sqdemSP"), ignore.stderr=TRUE)
  execGRASS("g.remove", parameters=list(rast="sqdemSP"), ignore.stderr=TRUE)
  writeRAST6(spear, "sqdemSP", zcol="sqdem", ignore.stderr=TRUE, useGDAL=TRUE)
  execGRASS("r.info", parameters=list(map="sqdemSP"), ignore.stderr=TRUE)
  execGRASS("g.remove", parameters=list(rast="sqdemSP"), ignore.stderr=TRUE)
}
}
\keyword{spatial}

