\name{Spatial-class}
\docType{class}
\alias{Spatial-class}
\alias{Spatial}
\alias{print.summary.Spatial}
\alias{summary,Spatial-method}
\alias{plot,Spatial,missing-method}
\alias{getParUsrBB}
\alias{setParUsrBB}
\alias{coordinates<-,Spatial-method}
\alias{[[<-,Spatial,ANY,missing-method}
\alias{[[,Spatial,ANY,missing-method}
\alias{$<-,Spatial-method}
\alias{$,Spatial-method}

\title{Class "Spatial"}
\description{ An abstract class from which useful spatial classes are
derived }
\section{Objects from the Class}{
are never to be generated; only derived classes can be meaningful }
\section{Slots}{
  \describe{
    \item{\code{bbox}:}{Object of class \code{"matrix"}; 2-column matrix
	holding the minimum in first and maximum in second column for the
	x-coordinate (first row), y-coordinate (second row) and optionally,
	for points and grids only, further coordinates. The constructed 
	Spatial object will be invalid if any bbox values are NA or infinite. The column names must be \code{c("min", "max")}}
    \item{\code{proj4string}:}{Object of class \code{"CRS"};
	holding a valid proj4 string, which can be used for unprojecting
	or reprojecting coordinates; it is initialised to NA. Other strings
	are checked for validity in the rgdal package, but attempts to assign a string containing "longlat" to data extending beyond longitude [-180, 360] or lattitude [-90, 90] will be stopped.}
  }
}
\section{Methods}{
  \describe{
    \item{bbox}{\code{signature(obj = "Spatial")}: retrieves the bbox element }
    \item{dimensions}{\code{signature(obj = "Spatial")}: retrieves the number
	of spatial dimensions spanned }
    \item{gridded}{\code{signature(obj = "Spatial")}: logical, tells whether
	the data is on a regular spatial grid }
    \item{plot}{\code{signature(x = "Spatial", y = "missing")}: plot method
	for spatial objects; does nothing but setting up a plotting region choosing
	a suitable aspect if not given(see below), colouring the plot background using either a bg= argument or par("bg"), and possibly drawing axes.  }
	\item{summary}{\code{signature(object = "Spatial")}: summarize object}
  }
}

\usage{
Spatial(bbox, proj4string = CRS(as.character(NA)))
}

\arguments{
\item{bbox}{a bounding box matrix}
\item{proj4string}{a CRS object}
}

\author{ r-spatial team; Edzer Pebesma, \email{edzer.pebesma@uni-muenster.de}
Roger Bivand, Barry Rowlinson, Virgilio G\'omez-Rubio
}
\note{  
	The default aspect for map plots is 1; if however data are not
	projected (coordinates are longlat), the aspect is by default set to
	1/cos(My * pi)/180) with My the y coordinate of the middle of the map
	(the mean of ylim, which defaults to the y range of bounding box).

The argument \code{setParUsrBB} may be used to pass the logical value \code{TRUE} to functions within \code{plot.Spatial}. When set to \code{TRUE}, par(\dQuote{usr}) will be overwritten with \code{c(xlim, ylim)}, which defaults to the bounding box of the spatial object. This is only needed in the particular context of graphic output to a specified device with given width and height, to be matched to the spatial object, when using par(\dQuote{xaxs}) and par(\dQuote{yaxs}) in addition to \code{par(mar=c(0,0,0,0))}.
}

\section{Warning }{this class is not useful in itself, but all spatial
classes in this package derive from it }

\seealso{
  \code{\link{SpatialPoints-class}},
  \code{\link{SpatialGrid-class}},
%  \code{\link{SpatialPolygons-class}},
%  \code{\link{SpatialArcs-class}},
  \code{\link{SpatialPointsDataFrame-class}},
  \code{\link{SpatialGridDataFrame-class}}
%  \code{\link{SpatialPolygonsDataFrame-class}},
}
%\examples{}

\keyword{classes}