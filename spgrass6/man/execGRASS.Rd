\name{execGRASS}
\alias{execGRASS}
\alias{doGRASS}
\alias{parseGRASS}
\alias{print.GRASS_interface_desc}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Run GRASS commands}
\description{
  The functions provide an interface to GRASS commands run through \code{system}, based on the values returned by the \code{--interface description} flag using XML parsing.
}
\usage{
execGRASS(cmd, flags = NULL, parameters = NULL, intern = FALSE, ignore.stderr = FALSE)
doGRASS(cmd, flags = NULL, parameters = NULL)
parseGRASS(cmd)
\method{print}{GRASS_interface_desc}(x, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{cmd}{GRASS command name}
  \item{flags}{character vector of GRASS command flags}
  \item{parameters}{list of GRASS command parameters}
  \item{intern}{a logical (not 'NA') which indicates whether to make the output of the command an R object. Not available unless 'popen' is supported on the platform}
  \item{ignore.stderr}{a logical indicating whether error messages written to 'stderr' should be ignored}
  \item{x}{object to be printed}
  \item{...}{other arguments to print method}
}
\details{
  \code{parseGRASS} checks to see whether the GRASS command has been parsed already and cached in this session; if not, it reads the interface description, parses it and caches it for future use. \code{doGRASS} assembles a proposed GRASS command with flags and parameters as a string, wrapping \code{parseGRASS}, and \code{execGRASS} is a wrapper for \code{doGRASS}, running the command through \code{system}. The command string is termed proposed, because not all of the particular needs of commands are provided by the interface description, and no check is made for the existence of input objects. Support for multiple parameter values added with help from Patrick Caldon.
}
\value{
  \code{parseGRASS} returns a \code{GRASS_interface_desc} object, \code{doGRASS} returns a character string with a proposed GRASS command, and \code{execGRASS} returns what \code{system} returns, particularly depending on the \code{intern} argument.
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link[base]{system}}}

\examples{
if (nchar(Sys.getenv("GISRC")) > 0) {
  print(parseGRASS("r.slope.aspect"))
  pars <- list(elevation="elevation.dem", slope="slope", aspect="aspect")
  doGRASS("r.slope.aspect", flags=c("overwrite"), parameters=pars)
  print(parseGRASS("r.buffer"))
  pars <- list(input="bugsites", output="bmap", distances=seq(1000,15000,1000))
  doGRASS("r.buffer", flags=c("overwrite"), parameters=pars)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{spatial}

