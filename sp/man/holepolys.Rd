\name{holepolys}
\alias{holepolys}
\alias{holepoly1}
\alias{holepoly2}

\docType{data}
\title{Hisaji Ono's hole problem}
\description{
  How to plot polygons with holes - holes are encoded by coordinates going anticlockwise, and overplotting is avoided by re-ordering the order in which polygons are plotted.
}
\usage{data(holepolys)}
\format{
  The format is class \code{"gpc.poly"} from package "gpclib".
}

\details{

"Date: Tue, 11 May 2004 12:54:20 +0900
From: Hisaji ONO 
To: r-help

 I've tried to create a polygon with one hole by gpclib using following
example script.

 holepoly <- read.polyfile(system.file("poly-ex/hole-poly.txt", package="gpclib"), nohole = FALSE)
 area.poly(holepoly)
 plot(holepoly,poly.args=list(col="red",border="blue"))

 And I noticed plot function couldn't draw polygons with holes correctly.

 Does anyone know how to solve this situation?"

*(holepoly1 has reversed the y component of polygon 1, to make its ring direction clockwise, holepoly2 reverses the order of the two polygons in holepoly1@pts)*

}

\source{
  Data file included in "gpclib" package.
}

\examples{
data(holepolys)
plot(gpcPoly2P4(holepoly1), col="red", pbg="white", border="blue")
plot(gpcPoly2P4(holepoly2), col="red", pbg="white", border="blue")
}

\keyword{datasets}
