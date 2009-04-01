\name{initGRASS}
\alias{initGRASS}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Initiate GRASS session}
\description{
  Run GRASS interface in an R session not started within GRASS. The function initializes environment variables used by GRASS, the .gisrc used by GRASS for further environment variables, and a temporary location.
}
\usage{
initGRASS(gisBase, home, SG, gisDbase, location, mapset, override = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gisBase}{The directory path to GRASS binaries and libraries}
  \item{home}{The directory in which to create the .gisrc file; defaults to \code{$HOME} on Unix systems and to \code{USERPROFILE} on Windows systems; can usually be set to \code{tempdir()}}
  \item{SG}{An optional \code{SpatialGrid} object to define the \code{DEFAULT_WIND} of the temporary location}
  \item{gisDbase}{if missing, \code{tempdir()} will be used; GRASS GISDBASE directory for the working session}
  \item{location}{if missing, \code{basename(tempfile())} will be used; GRASS location directory for the working session}
  \item{mapset}{if missing, \code{basename(tempfile())} will be used; GRASS mapset directory for the working session}
  \item{override}{default FALSE, set to TRUE if accidental trashing of GRASS .gisrc files and locations is not a problem}
}
\details{
  The function establishes an out-of-GRASS working environment providing GRASS commands with the environment variable support required, and may also provide a temporary location for use until the end of the running R session if the \code{home} argument is set to \code{tempdir()}, and the \code{gisDbase} argument is not given. Running \code{gmeta6} shows where the location is, should it be desired to archive it before leaving R.
}
\value{
  The function runs \code{gmeta6} before returning the current values of the running GRASS session that it provides.
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link{gmeta6}}}
\examples{
\dontrun{
initGRASS("/usr/local/grass-6.4.0", home=tempdir())
initGRASS("C:/GRASS", home=tempdir())
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{spatial}

