\name{is.projected}
% \alias{[.SpatialDataFrame}
\alias{is.projected}
\alias{proj4string}
\alias{proj4string<-}
\alias{spatial.dimension}

\title{ Sets or retrieves projection attributes on classes extending
SpatialData }
\description{ Sets or retrieves projection attributes on classes extending
SpatialData }
\usage{
is.projected(sd)
proj4string(sd)
proj4string(sd) <- value
spatial.dimension(sd)
}
\arguments{
  \item{sd}{An object of class or extending \link{SpatialData-class}}
  \item{value}{ character string, indicating a valid proj4 string }
}

\value{ \code{is.projected} returns a logical; \code{proj4string}
returns a character vector of length 1; \code{spatial.dimension}
returns the number of spatial dimensions (2 or 3).  }

\details{ proj4 strings are not operative yet }

\author{
  Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl}
}

\seealso{ \link{CRS} }

\examples{
data(meuse) 
coordinates(meuse) <- ~x+y
is.projected(meuse)
proj4string(meuse)
}

\keyword{spatial}
