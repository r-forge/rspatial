% Copyright (C) 2005 Roger S. Bivand
%
\name{readCELL6}
\alias{readCELL6}
\alias{readFLOAT6}
\alias{writeRast6}
\alias{arcGrid}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read and write GRASS 6 raster files}
\description{
  Read GRASS 6 raster files from GRASS 6 as ASCII Arc GRID files into R using GDAL; write R data as ASCII Arc GRID and read into GRASS 6 using r.in.gdal.
}
\usage{
readCELL6(vname, cat = FALSE)
readFLOAT6(vname)
writeRast6(df, vname, zcol = 3, xcol = 1, ycol = 2, NODATA=-9999, tol=1e-8)
arcGrid(xyz, file, zcol = 3, xcol = 1, ycol = 2, NODATA=-9999, tol=1e-8)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A GRASS 6.0 raster file}
  \item{cat}{For integer raster files, return a factor if TRUE}
  \item{df, xyz}{A data frame with cell centre coordinates and attributes}
  \item{file}{Output file for ASCII Arc GRID}
  \item{zcol}{Attribute column in df}
  \item{xcol}{Easting column in df}
  \item{ycol}{Northing column in df}
  \item{NODATA}{NODATA value (for DCELL, FCELL with many leading NODATA values, make floating point, eg. -9999.999}
  \item{tol}{Tolerance check for grid centre spacing to avoid outputting arbitrary data as grid}
}

\value{
  A data frame with north, east and vname columns when reading
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
}
\keyword{spatial}

