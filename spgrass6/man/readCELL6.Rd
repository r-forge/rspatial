% Copyright (C) 2005 Roger S. Bivand
%
\name{readCELL6}
\alias{readCELL6}
\alias{readFLOAT6}
\alias{writeRast6}
\alias{arcGrid}
\alias{readCELL6sp}
\alias{readFLOAT6sp}
\alias{writeRast6sp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read and write GRASS 6 raster files}
\description{
  Read GRASS 6 raster files from GRASS 6 as ASCII Arc GRID files into R using GDAL or read.asciigrid in the sp package; write R data as ASCII Arc GRID and read into GRASS 6 using r.in.gdal. Data may be read into a data frame, or into the SpatialGridDataFrame object introduced in the sp package.
}
\usage{
readCELL6(vname, cat = FALSE)
readFLOAT6(vname)
writeRast6(df, vname, zcol = 3, xcol = 1, ycol = 2, NODATA=-9999, tol=1e-8)
arcGrid(xyz, file, zcol = 3, xcol = 1, ycol = 2, NODATA=-9999, tol=1e-8)
readCELL6sp(vname, cat=FALSE)
readFLOAT6sp(vname)
writeRast6sp(x, vname, zcol = 1, NODATA=-9999)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A GRASS 6.0 raster file}
  \item{cat}{For integer raster files, return a factor if TRUE}
  \item{df, xyz}{A data frame with cell centre coordinates and attributes}
  \item{file}{Output file for ASCII Arc GRID}
  \item{zcol}{Attribute column number}
  \item{xcol}{Easting column in df}
  \item{ycol}{Northing column in df}
  \item{NODATA}{NODATA value (for DCELL, FCELL with many leading NODATA values, make floating point, eg. -9999.999}
  \item{tol}{Tolerance check for grid centre spacing to avoid outputting arbitrary data as grid}
  \item{x}{A SpatialGridDataFrame object for export to GRASS as a raster layer}
}

\value{
 readCELL6 and readFLOAT6 return data frames with north, east and vname columns;
 readCELL6sp and readFLOAT6sp return SpatialGridDataFrame objects with data frames in the data slots, and with the projection argument set.
}

\note{At present the functions do not operate on multiple rasters}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
\dontrun{dem <- readFLOAT6("elevation.dem")}
\dontrun{geol <- readCELL6("geology", cat = TRUE)}
\dontrun{table(geol$geology)}
\dontrun{system("r.stats -cl geology")}
\dontrun{boxplot(dem$elevation.dem ~ geol$geology)}
\dontrun{dem$sqdem <- sqrt(dem$elevation.dem)}
\dontrun{range(dem$sqdem, na.rm=TRUE)}
\dontrun{writeRast6(dem, "sqdem", zcol=4, NODATA=-9999.99)}
\dontrun{system("r.info sqdem")}
\dontrun{dem <- readFLOAT6sp("elevation.dem")}
\dontrun{geol <- readCELL6sp("geology", cat = TRUE)}
\dontrun{table(geol$geology)}
\dontrun{system("r.stats -cl geology")}
\dontrun{boxplot(dem$elevation.dem ~ geol$geology)}
\dontrun{dem$sqdem <- sqrt(dem$elevation.dem)}
\dontrun{writeRast6sp(dem, "sqdemSP", zcol=2, NODATA=-9999.99)}
\dontrun{system("r.info sqdemSP")}
}
\keyword{spatial}

