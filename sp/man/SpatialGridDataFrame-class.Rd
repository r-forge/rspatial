\name{SpatialGridDataFrame-class}
\docType{class}
\alias{SpatialGridDataFrame-class}
\alias{[,SpatialGridDataFrame-method}
\alias{[[,SpatialGridDataFrame-method}
\alias{[[<-,SpatialGridDataFrame-method}
% \alias{SpatialGridDataFrame}
\alias{plot.SpatialGridDataFrame}
\alias{print.summary.SpatialGridDataFrame}
\alias{summary.SpatialGridDataFrame}
\alias{coerce,SpatialGridDataFrame,SpatialPointsDataFrame-method}
\alias{coerce,SpatialGridDataFrame,data.frame-method}
\alias{coerce,SpatialGridDataFrame,matrix-method}
\alias{as.data.frame.SpatialGridDataFrame}

\title{Class "SpatialGridDataFrame" ~~~ }
\description{  Class for spatial attributes that have spatial locations
on a regular grid. }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{as(x,
"SpatialGridDataFrame")}, where \code{x} is of class
\link{SpatialPointsDataFrame-class}, or by importing through rgdal.  
Ordered full grids are stored instead or unordered non-NA cells; 
}

\section{Slots}{
  \describe{
    \item{\code{data}:}{Object of class \code{"data.frame"}; attribute data }
    \item{\code{centre.offset}:}{see \link{SpatialGrid}; grid parameters }
    \item{\code{cellsize}:}{see \link{SpatialGrid}; grid parameters }
    \item{\code{cellsidim}:}{see \link{SpatialGrid}; grid parameters }
    \item{\code{bbox}:}{Object of class \code{"matrix"}; bounding box }
    \item{\code{proj4string}:}{Object of class \code{"CRS"}; projection }
  }
}
\section{Extends}{
Class \code{"SpatialGrid"}, directly.
Class \code{"Spatial"}, by class \code{"SpatialGrid"}.
}
\section{Methods}{
  \describe{
    \item{coordinates}{\code{signature(x = "SpatialGridDataFrame")}: retrieves (and calculates!) coordinates }
    \item{[}{\code{signature(x = "SpatialGridDataFrame")}: selects single attribute, and returns an
	object of class \code{SpatialGridDataFrame}}
    \item{[[}{\code{signature(x = "SpatialGridDataFrame")}: retrieves an attribute, dropping everything 
	else (topology) }
    \item{[[<-}{\code{signature(x = "SpatialGridDataFrame")}: assigns or replaces an attribute }
	\item{as.matrix}{\code{signature(x = "SpatialGridDataFrame")}: coerce to matrix }
  }
}

\references{  }
\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }
\note{  }

\seealso{
  \code{\link{SpatialGrid-class}}, which does not contain the attribute data
}
\examples{
data(meuse.grid) # only the non-missing valued cells
coordinates(meuse.grid) = c("x", "y") # promote to SpatialPointsDataFrame
gridded(meuse.grid) <- TRUE # promote to SpatialGridDataFrame
x = as(meuse.grid, "SpatialGridDataFrame") # creates the full grid
x[["idist"]] = 1 - x[["dist"]] # assigns new attribute
image(x["idist"]) # note the single [

# toy example:
df = data.frame(z = c(1:6,NA,8,9),
    xc = c(1,1,1,2,2,2,3,3,3),
    yc = c(rep(c(0, 1.5, 3),3)))
coordinates(df) = ~xc+yc
gridded(df) = TRUE
image(df["z"])
# draw labels to verify:
cc = coordinates(df)
z=df[["z"]]
zc=as.character(z)
zc[is.na(zc)]="NA"
text(cc[,1],cc[,2],zc)

}
\keyword{classes}
