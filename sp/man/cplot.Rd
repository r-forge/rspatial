\name{cplot}
\alias{cplot}
\title{coloured points plot}
\description{plot coloured points using xyplot }
\usage{
cplot(obj, zcol = 1, fill = TRUE, pch, 
	col = bpy.colors(ifelse(length(cuts)>1, length(cuts)-1, cuts)), 
	cex = 1, cuts = 5, main = ifelse(is.numeric(zcol), names(data)[zcol], zcol),
    identify = FALSE, labels = row.names(data.frame(obj)), do.log =
    FALSE, ...)
}
\arguments{
\item{obj}{ object of class (or extending) \link{SpatialPoints}, but mostly useful
when extending \link{SpatialPointsDataFrame} }
\item{zcol}{ column name or number in data.frame part of obj }
\item{fill}{ logical; use filled symbols? }
\item{pch }{ plotting character to use; defaults to 16 if fill is TRUE, else 1 }
\item{col }{ colors to use }
\item{cex}{ symbol size }
\item{cuts}{ number of classes, or class boundaries }
\item{main}{ main title }
\item{identify}{ identify points in plot (not yet working) }
\item{labels}{ labels for identification }
\item{do.log}{ logical; if TRUE choose cuts linear on the log-scale, else choose
them linear on the working scale. }
\item{...}{ arguments passed to \link{xyplot}}
}
\value{
a lattice plot of class "trellis"
}
\references{
}
\seealso{
\link{bubble}
}
\author{
Edzer J. Pebesma, \url{mailto:e.pebesma@geog.uu.nl}
}
\examples{
data(meuse)
coordinates(meuse) <- ~x+y
cplot(meuse) # prints cadmium
cplot(meuse, "zinc")
cplot(meuse, "zinc", do.log = TRUE, main = "zinc; logarithmic scale breaks")
}
\keywords{dplot}
