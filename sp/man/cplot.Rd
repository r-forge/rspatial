\name{cplot}
\alias{cplot}
\title{coloured points plot}
\description{plot coloured points using xyplot }
\usage{
cplot(obj, zcol = 1, cuts = 5, ..., fill = TRUE, pch, col,
	cex = 1, main = ifelse(is.numeric(zcol), names(data)[zcol], zcol),
    identify = FALSE, labels = row.names(data.frame(obj)), do.log =
    FALSE, legend, space = "right")
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
\item{identify}{ identify points in a lattice plot }
\item{labels}{ labels for identification }
\item{do.log}{ logical; if TRUE choose cuts linear on the log-scale, else choose
them linear on the working scale. }
\item{legend}{ character; array with legend (text) entries; suitable defaults are
sought. }
\item{space}{ locations where the legend is placed: "right", "left", "top", 
or "bottom"}
\item{...}{ arguments passed to \link{xyplot}}
}
\value{
a lattice plot of class "trellis"; if \code{identify} is TRUE, the row
numbers of the selected points are returned.
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
if (require(RColorBrewer)) {
	cplot(meuse, "ffreq", col = brewer.pal(3, "Set1"),
		main = "flood frequency; RColorBrewer Set1")
}
}
\keyword{dplot}
