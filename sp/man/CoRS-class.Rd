\name{CoRS-class}
\docType{class}
\alias{CoRS-class}
\alias{CoRS}
\alias{CoRSargs}
\alias{print.CoRS}
\alias{show,CoRS-method}
\title{Class "CoRS" of PROJ.4 projection arguments}
\description{Interface to the PROJ.4 projection system.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{CoRS("projargs")}, where "projargs" is a valid string of PROJ.4 arguments. The initiation function calls the PROJ.4 library to verify the argument set against those known in the library, returning error messages where necessary. The complete argument set may be retrieved by examining the second list element returned by \code{validObject("CoRS object")} to see which additional arguments the library will use (which assumptions it is making over and above submitted arguments). The function \code{CoRSargs()} can be used to show the expanded argument list used by the PROJ.4 library.
}
\section{Slots}{
  \describe{
    \item{\code{projargs}:}{Object of class \code{"character"}: projection arguments }
  }
}

\section{Methods}{
  \describe{
    \item{show}{\code{signature(object = "CoRS")}: print projection arguments in object }
  }
}
\references{\url{http://www.remotesensing.org/proj/}}
\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\notes{
Lists of projections may be seen by using the programs installed with the PROJ.4 library, in particular proj and cs2cs; with the latter, -lp lists projections, -le ellipsoids, -lu units, and -ld datum(s) known to the installed software. These are added to in successive releases, so tracking the website or compiling and installing the most recent revisions will give the greatest choice. On occasion, ellipsoid parameters may be passed through directly. Tracing projection arguments is easier now than before the mass ownership of GPS receivers raised the issue of matching coordinates from different argument sets (GPS output and paper map, for example).}

\seealso{\code{\link{transform-methods}}, \code{\link{project}}}

\examples{
CoRS("+proj=utm +zone=32 +datum=WGS84 +ellps=GRS80")
# Current Norwegian UTM(EUREF89) zone 32
CoRS(paste("+proj=tmerc +ellps=bess_nam +a=6377492.0176",
 "+lat_0=58 +lon_0=10.72291666666667 +k=1.000000 +x_0=0 +y_0=0",
 "+towgs84=278.3,93,474.5,7.889,0.05,-6.61,6.21 +pm=oslo"))
# Norwegian NGO1948 zone III (more or less)
CoRS("+proj=utm +zone=32 +ellps=intl +datum=potsdam")
# Norwegian UTM(ED50) zone 32
CoRS("+proj=latlong +datum=WGS84")
# Geographical coordinates, WGS84 datum
CoRSargs(CoRS("+proj=latlong +datum=WGS84"))
}
\keyword{classes}
\keyword{spatial}
