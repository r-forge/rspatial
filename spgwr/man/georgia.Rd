\name{georgia}
\alias{georgia}
\docType{data}
\title{Georgia census data set (SpatialDataFramePolygons)}
\description{
  The Georgia census data set from Fotherinham et al. (2002) in SpatialDataFramePolygons format (depending on draft package "sp").
}
\usage{data(georgia)}
\format{
 A SpatialDataFramePolygons object with proj4string "+proj=latlong +datum=NAD27". There is a small hole in the middle resulting from the original form of the Census shapefile.

  The "data" slot is a data frame with 159 observations on the following 22 variables.
  \describe{
    \item{AreaKey}{a numeric vector}
    \item{AREA}{a numeric vector}
    \item{PERIMETER}{a numeric vector}
    \item{\code{CO13_D90_}}{a numeric vector}
    \item{\code{CO13_D90_I}}{a numeric vector}
    \item{ST}{a factor with levels \code{13} (state FIPS code)}
    \item{CO}{a factor with levels for county FIPS codes}
    \item{NAME}{a factor with levels for county names}
    \item{Latitude}{a numeric vector}
    \item{Longitud}{a numeric vector}
    \item{TotPop90}{a numeric vector}
    \item{PctRural}{a numeric vector}
    \item{PctBach}{a numeric vector}
    \item{PctEld}{a numeric vector}
    \item{PctFB}{a numeric vector}
    \item{PctPov}{a numeric vector}
    \item{PctBlack}{a numeric vector}
    \item{ID}{a numeric vector}
    \item{X}{a numeric vector}
    \item{Y}{a numeric vector}
    \item{X1}{a numeric vector}
    \item{X2}{a numeric vector}
  }
}
\details{
Variables AREA:NAME are from the US Census 1990 shapefile for Georgia counties, the remainder are from GWR3 file GeorgiaData.csv.
}
\source{
  \url{http://www.census.gov/geo/cob/bdy/co/co90shp/co13_d90_shp.zip}; \url{http://www.ncl.ac.uk/~ngeog/GWR/}
}
\references{
  Fotheringham, A.S., Brunsdon, C., and Charlton, M.E., 2002, Geographically Weighted Regression: The Analysis of Spatially Varying Relationships, Chichester: Wiley.
}
\examples{
data(georgia)
plot(georgia)
}
\keyword{datasets}
