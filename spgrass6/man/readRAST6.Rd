% Copyright (C) 2005-7 Roger S. Bivand
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


}
\usage{
readRAST6(vname, cat=NULL, ignore.stderr = FALSE, NODATA=-9999)
writeRAST6(x, vname, zcol = 1, NODATA=-9999, ignore.stderr = FALSE)
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
  \item{x}{A SpatialGridDataFrame object for export to GRASS as a raster layer}
  \item{zcol}{Attribute column number or name}
  \item{NODATA}{NODATA value}
%  \item{colname}{alternative name for data column if not file basename}
%  \item{integer}{logical value: TRUE if the input data is integer}
}

\value{
\code{readRAST6} returns a SpatialGridDataFrame objects with an AttributeList in the data slots, and with the projection argument set.
}

\note{In readRAST6, when any cat= argument values are TRUE, it may appear that a system call to r.stats has failed. This is caused by the existence of older and newer GRASS 6 versions, using -q or --q as quiet flags. If -q fails, --q is tried, so the error message will be seen on newer GRASS 6 installations. If it is found an inconvenience, the ignore.stderr argument should be set to TRUE.}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  spear <- readRAST6(c("geology", "elevation.dem"), cat=c(TRUE, FALSE),
    ignore.stderr=TRUE)
  table(spear$geology)
  if (Sys.getenv("OSTYPE") == "msys") system("r.stats.exe -q -cl geology")
  else system("r.stats -q -cl geology")
  boxplot(spear$elevation.dem ~ spear$geology)
  spear$sqdem <- sqrt(spear$elevation.dem)
  writeRAST6(spear, "sqdemSP", zcol="sqdem", NODATA=-9999.99, ignore.stderr=TRUE)
  if (Sys.getenv("OSTYPE") == "msys")
    system("r.info.exe sqdemSP", ignore.stderr=TRUE)
  else system("r.info sqdemSP", ignore.stderr=TRUE)
  if (Sys.getenv("OSTYPE") == "msys") system("g.remove.exe rast=sqdemSP")
  else system("g.remove rast=sqdemSP")
  if (Sys.getenv("OSTYPE") == "msys")
    system("r.mapcalc.exe quads0 = quads - 1", ignore.stderr=TRUE)
  else system("r.mapcalc \'quads0 = quads - 1\'", ignore.stderr=TRUE)
  if (Sys.getenv("OSTYPE") == "msys")
    system("r.stats.exe -c quads0", ignore.stderr=TRUE)
  else system("r.stats -c quads0", ignore.stderr=TRUE)
  quads0 <- readRAST6("quads0", ignore.stderr=TRUE)
  table(quads0$quads0)
  quads0 <- readRAST6("quads0", ignore.stderr=TRUE, NODATA=0)
  table(quads0$quads0)
  if (Sys.getenv("OSTYPE") == "msys") system("g.remove.exe rast=quads0")
  else system("g.remove rast=quads0")
}
}
\keyword{spatial}

