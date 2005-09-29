% Copyright (C) 2005 Roger S. Bivand
%
\name{readCELL6sp}
\alias{readCELL6sp}
\alias{readFLOAT6sp}
\alias{writeRast6sp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read and write GRASS 6 raster files}
\description{
  Read GRASS 6 raster files from GRASS 6 as ASCII Arc GRID files into R using readAsciiGrid in the maptools package; write R data as ASCII Arc GRID and read into GRASS 6 using r.in.gdal. Data are read into the SpatialGridDataFrame object introduced in the sp package.
}
\usage{
readCELL6sp(vname, cat=NULL)
readFLOAT6sp(vname)
writeRast6sp(x, vname, zcol = 1, NODATA=-9999)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A vector of GRASS 6.0 raster file names}
  \item{cat}{default NULL; if not NULL, must be a logical vector matching vname, stating which (CELL) rasters to return as factor}
  \item{x}{A SpatialGridDataFrame object for export to GRASS as a raster layer}
  \item{zcol}{Attribute column number}
  \item{NODATA}{NODATA value (for DCELL, FCELL with many leading NODATA values, make floating point, eg. -9999.999}
}

\value{
 readCELL6sp and readFLOAT6sp return SpatialGridDataFrame objects with data frames in the data slots, and with the projection argument set.
}


\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  spear <- readCELL6sp(c("geology", "elevation.dem"), cat=c(TRUE, FALSE))
  table(spear$geology)
  system("r.stats -cl geology")
  boxplot(spear$elevation.dem ~ spear$geology)
  spear$sqdem <- sqrt(spear$elevation.dem)
  writeRast6sp(spear, "sqdemSP", zcol="sqdem", NODATA=-9999.99)
  system("r.info sqdemSP")
}
}
\keyword{spatial}

