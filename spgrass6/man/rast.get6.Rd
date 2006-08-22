% Copyright (C) 2005 Roger S. Bivand
%
\name{rast.get6}
\alias{rast.get6}
\alias{rast.put6}
\alias{readCELL6sp}
\alias{readFLOAT6sp}
\alias{writeRast6sp}
\alias{readRAST6}
\alias{readBinGrid}
\alias{writeRAST6}
\alias{writeBinGrid}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read and write GRASS 6 raster files}
\description{
  Read GRASS 6 raster files from GRASS 6 as ASCII Arc GRID files into R using readAsciiGrid in the maptools package; write R data as ASCII Arc GRID and read into GRASS 6 using r.in.gdal. Data are read into the SpatialGridDataFrame object introduced in the sp package.

\code{readRAST6} and \code{writeRAST6} use temporary binary files and r.out.bin and r.in.bin rather than temporary ASCII files. 
}
\usage{
rast.get6(vname, cat=NULL, ignore.stderr = FALSE)
rast.put6(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE)
readCELL6sp(vname, cat=NULL, ignore.stderr = FALSE)
readFLOAT6sp(vname, ignore.stderr = FALSE)
writeRast6sp(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE)
readRAST6(vname, cat=NULL, ignore.stderr = FALSE)
readBinGrid(fname, colname=basename(fname), proj4string=CRS(as.character(NA)), integer)
writeRAST6(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE)
writeBinGrid(x, fname, attr = 1, na.value = -9999)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A vector of GRASS 6.0 raster file names}
  \item{fname}{file name}
  \item{proj4string}{A CRS object setting the projection arguments of the Spatial Grid returned}
  \item{cat}{default NULL; if not NULL, must be a logical vector matching vname, stating which (CELL) rasters to return as factor}
  \item{ignore.stderr}{default FALSE, can be set to TRUE to silence \code{system()} output to standard error; does not apply on Windows platforms}
  \item{x}{A SpatialGridDataFrame object for export to GRASS as a raster layer}
  \item{zcol,attr}{Attribute column number}
  \item{NODATA,na.value}{NODATA value (for DCELL, FCELL with many leading NODATA values, make floating point, eg. -9999.999}
  \item{colname}{alternative name for data column if not file basename}
  \item{integer}{logical value: TRUE if the input data is integer}
}

\value{
 \code{rast.get6} and \code{readRAST6} return SpatialGridDataFrame objects with an AttributeList in the data slots, and with the projection argument set (readCELL6sp and readFLOAT6sp are wrapped inside rast.get6).
}


\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  system.time(spear <- rast.get6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE), ignore.stderr=TRUE))
  system.time(spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE), ignore.stderr=TRUE))
  table(spear$geology)
  system("r.stats -q -cl geology", ignore.stderr=TRUE)
  boxplot(spear$elevation.dem ~ spear$geology)
  spear$sqdem <- sqrt(spear$elevation.dem)
  system.time(rast.put6(spear, "sqdemSP", zcol="sqdem", NODATA=-9999.99, ignore.stderr=TRUE))
  system.time(writeRAST6(spear, "sqdemSP1", zcol="sqdem", NODATA=-9999.99, ignore.stderr=TRUE))
  system("r.info sqdemSP", ignore.stderr=TRUE)
  system("g.remove rast=sqdemSP", ignore.stderr=TRUE)
  system("r.info sqdemSP1", ignore.stderr=TRUE)
  system("g.remove rast=sqdemSP1", ignore.stderr=TRUE)
}
}
\keyword{spatial}

