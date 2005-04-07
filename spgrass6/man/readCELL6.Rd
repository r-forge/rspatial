\name{readCELL6}
\alias{readCELL6}
\alias{readFLOAT6}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{}
\description{
  
}
\usage{
readCELL6(vname, cat = FALSE)
readFLOAT6(vname)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{vname}{A GRASS 6.0 raster file}
  \item{cat}{}
}

\value{
  A data frame with north, east and vname columns
}

\author{Roger S. Bivand, e-mail: \email{Roger.Bivand@nhh.no.}}

\examples{
\dontrun{dem <- readFLOAT6("elevation.dem")}
\dontrun{geol <- readCELL6("geology", cat = TRUE)}
\dontrun{table(geol$geology)}
\dontrun{system("r.stats -cl geology")}
\dontrun{boxplot(dem$elevation.dem ~ geol$geology)}
}
\keyword{spatial}

