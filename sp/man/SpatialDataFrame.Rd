\name{SpatialDataFrame}
\alias{SpatialDataFrame}
\alias{formula.SpatialDataFrame}
\alias{plot.SpatialDataFrame}
% \alias{plot.SpatialDataFrameGrid}
\alias{print.SpatialDataFrame}
\alias{summary.SpatialDataFrame}
\alias{row.names.SpatialDataFrame}
\alias{row.names.SpatialDataFrameGrid}
\alias{formula.SpatialDataFrameGrid}
\alias{summary.SpatialDataFrameGrid}

\title{Create a SpatialDataFrame }
\description{ Creates a SpatialDataFrame, a data.frame that is aware in
which columns its spatial coordinates are stored, or retrieves
coordinate values }
\usage{
SpatialDataFrame(data, coord.names, coord.columns, proj4string = "") 
formula.SpatialDataFrame(x, ...)
plot.SpatialDataFrame(x, xlab = x@coord.names[1], ylab = x@coord.names[2], 
	asp = 1, ...)
print.SpatialDataFrame(x, ...)
summary.SpatialDataFrame(object, ...)
row.names.SpatialDataFrame(x)
row.names.SpatialDataFrameGrid(x)
}
\arguments{
  \item{data}{ An object of class data.frame, or an object assigned NULL }
  \item{coord.names}{coordinate names, present as column names in data}
  \item{coord.columns}{coordinate column numbers, present in data}
  \item{proj4string}{character; refers to projection used}
  \item{x}{object of class SpatialDataFrame}
  \item{object}{object of class SpatialDataFrame}
  \item{xlab}{ x axis label}
  \item{ylab}{ y axis label}
  \item{asp}{ aspect ratio of unit on x and y axis; usually 1 for maps }
  \item{...}{ ignored }
}
\value{
  The first function creates an object of class \code{SpatialDataFrame};
  slots of this S4 class are described in \link{SpatialDataFrame-class}.
  \code{formula.SpatialDataFrame} extracts the coordinate names in a
  formula form; \code{plot.SpatialDataFrame} plots the data as a map;
  \code{print.SpatialDataFrame} prints the data with marked coordinates;
  \code{summary.SpatialDataFrame} gives a summary of a SpatialDataFrame.
}

\details{ }

\author{ Edzer J. Pebesma, \email{e.pebesma@geog.uu.nl} }

\seealso{ \link{SpatialDataFrame-class}, 
\link{SpatialDataFrameGrid-class},
\link{SpatialData-class}, \link{coordinates} }

\examples{
data(meuse) # data.frame
coordinates(meuse) <- c("x", "y") # promotes meuse to SpatialDataFrame
formula(meuse)
plot(meuse)
summary(meuse)
}

\keyword{spatial}
