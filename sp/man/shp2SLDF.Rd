\name{shp2SLDF}
\alias{shp2SLDF}
\alias{arcobj2SLDF}
\alias{contourLines2SLDF}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Converter functions to build SpatialLinesDataFrame objects}
\description{
  These functions show how to build converters from external formats to build SpatialLinesDataFrame objects: \code{shp2SLDF} from \code{"arc"} type ESRI shapefiles read into \code{"Map"} objects using the \code{read.shape()} function in the maptools package; \code{arcobj2SLDF} from the list returned by the \code{get.arcdata} function in the RArcInfo package; and \code{contourLines2SLDF} from the list returned by the \code{contourLines} function in the graphics package (here the data frame is just the contour levels, with one Slines object made up of at least one Sline object per level). 
}
\usage{
shp2SLDF(shp, proj4string = CRS(as.character(NA)))
arcobj2SLDF(arc, proj4string=CRS(as.character(NA)))
contourLines2SLDF(cL, proj4string=CRS(as.character(NA)))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{shp}{a \code{"Map"} object returned by the \code{read.shape()} function in the maptools package}
  \item{arc}{a list returned by the \code{get.arcdata} function in the RArcInfo package}
  \item{cL}{a list returned by the \code{contourLines} function in the graphics package}
  \item{proj4string}{Object of class \code{"CRS"}; see \link{CRS-class}}
}

\value{
  A SpatialLinesDataFrame object
}

\author{ Roger Bivand; Edzer Pebesma }


\seealso{ \link{SpatialLines-class} }
\examples{
data(lnsshp)
res <- shp2SLDF(lns)
plot(res)
data(co37_d90_arc)
res <- arcobj2SLDF(arc)
plot(res)
data(meuse_interp_cL)
res <- contourLines2SLDF(cL)
plot(res, col=terrain.colors(nrow(res@data)))
res <- contourLines2SLDF(contourLines(volcano))
plot(res, col=terrain.colors(nrow(res@data)))
}
\keyword{spatial}
