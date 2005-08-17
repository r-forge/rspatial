\name{as.SpatialRings.GridTopology}
\alias{as.SpatialRings.GridTopology}
\alias{IDvaluesGridTopology}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Make SpatialRings object from GridTopology object}
\description{
  Converts grids of regular rectangles into a \code{SpatialRings} object, which can be transformed to a different projection or datum. The function is not suitable for high-resolution grids. The ordering of the grid cells is as in \code{coordinates()} of the same object, and is reported by \code{IDvaluesGridTopology}.
}
\usage{
as.SpatialRings.GridTopology(grd, proj4string = CRS(as.character(NA)))
IDvaluesGridTopology(obj)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{grd,obj}{\code{GridTopology} object}
  \item{proj4string}{projection string of class CRS}
}

\value{
  \code{as.SpatialRings.GridTopology} returns a \code{SpatialRings} object;
\code{IDvaluesGridTopology} returns a character vector with the \code{GridTopology} object column and row indices.
}

\seealso{\code{\link{GridTopology}}, \code{\link{SpatialRings}}}

\examples{
grd <- GridTopology(cellcentre.offset=c(-175,55), cellsize=c(10,10), cells.dim=c(4,4))
SR_grd <- as.SpatialRings.GridTopology(grd)
plot(SR_grd)
text(getSRSringsLabptSlots(SR_grd), getSRSringsIDSlots(SR_grd), cex=0.5)
trdata <- data.frame(A=rep(c(1,2,3,4), 4), B=rep(c(1,2,3,4), each=4), row.names=getSRSringsIDSlots(SR_grd))
SRDF <- SpatialRingsDataFrame(SR_grd, trdata)
spplot(SRDF)
}
\keyword{spatial}
