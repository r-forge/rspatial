\name{bpy.colors}
\alias{bpy.colors}
\title{ blue-pink-yellow color scheme that prints well on black/white printers }
\description{ Create a vector of `n' ``contiguous'' colors.  }
\usage{ bpy.colors(n = 100, cutoff.tails = 0.1) }
\arguments{
\item{n}{number of colors (>= 1) to be in the palette}
\item{cutoff.tails}{tail fraction to be cut off. This palette can run
from black to white; by cutting off the tails, it runs from blue 
to yellow, which looks nicer. }
}
\value{ A character vector, `cv', of color names.  This can be used
either to create a user-defined color palette for subsequent graphics
by `palette(cv)', a `col=' specification in graphics functions or in
`par'.  }
\references{ see url; gnuplot has this color map }
\author{ unknown }
\url{ http://www.ihe.uni-karlsruhe.de/mitarbeiter/vonhagen/palette.en.html }
\note{ This color map prints well on black-and-white printers. }
\seealso{\link{rainbow}, \link{cm.colors}}
\examples{
bpy.colors(10)
p <- expand.grid(x=1:30,y=1:30)
p$z <- p$x + p$y
coordinates(p) <- c("x", "y")
gridded(p) <- TRUE
image.default(as.image.SDFG(p), col = bpy.colors(100), asp = 1)
require(lattice)
# trellis.par.set("regions", list(col=bpy.colors())) # make default pallette
}
\keyword{color}
