\name{spplot}
\alias{spplot}
\alias{layout.north.arrow}
\alias{layout.scale.bar}
\alias{mapLegendGrob}
\alias{sp.theme}
\title{Lattice (trellis) plots for spatial data}
\description{plots for points, grids, polygons }
\usage{
spplot(obj, zcol, ..., names.attr, 
	scales = list(draw = FALSE), xlab = "", ylab = "", aspect = mapasp(obj), 
	sp.layout = NULL, plot.all = TRUE, identify = FALSE)
mapLegendGrob(obj, widths = unit(1, "cm"), heights = unit(1, "cm"),
	fill = "black", just = "right")
sp.theme()
layout.north.arrow()
layout.scale.bar(height = 0.05)
}
\arguments{
\item{obj}{ object of class extending \link{Spatial-class}} 
\item{zcol}{ character; attribute name(s) or column number(s) in attribute table }
\item{names.attr}{ names to use in panel, if different from attribute names }
\item{scales}{ scales argument to be passed to Lattice plots; use
\code{list(draw = TRUE)} to draw axes scales; see \link{xyplot} for full options }
\item{...}{ other arguments passed to \link{levelplot} (grids, polygons) or 
\link{xyplot} (points) }
\item{xlab}{label for x-axis (default empty) }
\item{ylab}{label for y-axis (default empty) }
\item{aspect}{aspect ratio for spatial axes; defaults to "iso" (one unit
on the x-axis equals one unit on the y-axis) but may be set to more
suitable values if the data are e.g. in degrees latitude/longitude }
\item{sp.layout}{NULL or list; see notes below}
\item{plot.all}{logical; if TRUE and \code{zcol} is missing, plot all
attributes; if FALSE and \code{zcol} is missing only plot first attribute }
\item{identify}{ identify plotted objects (currently only working
for points plots); labels for identification are the row.names of the
attribute table \code{row.names(as.data.frame(obj))}}
\item{widths}{width of grob}
\item{heights}{heights of grob}
\item{fill}{fill color of grob}
\item{just}{grob placement justification}
\item{height}{height of scale bar; width is 1.0}
}
\value{
a lattice plot of class "trellis"; if \code{identify} is TRUE, the row
names of the selected points.
}
\note{
Useful arguments that can be passed are: 
\describe{
\code{layout}{for the layout of panels}
\code{col.regions}{to specify fill colours}
\code{pretty}{ for colour breaks at pretty numbers}
\code{at}{to specify at which values colours change}
\code{as.table}{to start drawing panels upper-left instead
of lower-left}
\code{page}{to add marks to each plotted page} for values
}
for useful values see the appropriate documentation of \link{xyplot}
and \link{levelplot}.

If \code{obj} is of SpatialPointsDataFrame, the following options are
useful to pass:
\describe{
\item{key.space}{ character: "bottom", "right", "left" or "right" to denote
key location, or list: see argument key in the help for \link{xyplot} what
the options are}
\item{legendEntries}{ character; array with key legend (text) entries; 
suitable defaults obtained from data }
\item{cuts}{number of cuts or the actual cuts to use}
\item{do.log}{logical; if TRUE use log-linear scale to divide range in equal cuts,
else use a linear scale if \code{cuts} is only number of cuts }
\item{pch }{ integer; plotting character to use; defaults to 16 if fill is TRUE, else 1 }
\item{cex}{numeric; character expansion, proportional to default value of 1}
\item{fill}{ logical; use filled circles? }
}
}

\references{
}
\seealso{
}
\author{
Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl}
}
\examples{
library(lattice)
trellis.par.set(sp.theme()) # sets bpy.colors() ramp
data(meuse)
coordinates(meuse) <- ~x+y
l2 = list("SpatialRingsRescale", layout.north.arrow(), offset = c(181300,329800), 
	scale = 400)
l3 = list("SpatialRingsRescale", layout.scale.bar(), offset = c(180500,329800), 
	scale = 500, fill=c("transparent","black"))
l4 = list("sp.text", c(180500,329900), "0")
l5 = list("sp.text", c(181000,329900), "500 m")

spplot(meuse, c("ffreq"), sp.layout=list(l2,l3,l4,l5),col.regions="black",pch=c(1,2,3),
	key.space=list(x=0.1,y=.95,corner=c(0,1)))
spplot(meuse, c("zinc", "lead"), sp.layout=list(l2,l3,l4,l5, which = 2),
	key.space=list(x=0.1,y=.95,corner=c(0,1)))

if (require(RColorBrewer)) {
	spplot(meuse, c("ffreq"), sp.layout=list(l2,l3,l4,l5),
		col.regions=brewer.pal(3, "Set1"))
}
}
\keyword{dplot}
