\name{transform-methods}
\docType{methods}
\title{ Methods for Function transform in package "sp" }
\alias{transform-methods}
\alias{transform,ANY-method}
\alias{transform,SpatialDataFrame-method}
\alias{transform,Polylist4-method}
\alias{transform,Polygon4-method}
\alias{transform.SpatialDataFrame}
\alias{transform.Polylist4}
\alias{transform.Polygon4}
\section{Methods}{\describe{

\item{x = "ANY"}{default void method}

\item{x = "SpatialDataFrame", CoRSobj = CoRS}{returns transformed coordinates of an "SpatialDataFrame" object using the projection arguments in "CoRSobj", of class CoRS}
\item{x = "Polylist4", CoRSobj = CoRS}{returns transformed coordinates of the "Polygon4" objects in the polygons slot of an "Polylist4" object using the projection arguments in "CoRSobj", of class CoRS}

\item{x = "Polygon4", CoRSobj = CoRS}{returns transformed coordinates of an "Polygon4" object using the projection arguments in "CoRSobj", of class CoRS}

}}
\description{Transformation in package "sp" is concerned with transformation between datum(s) and conversion between projections, from one unambiguously specified coordinate reference system to another, using PROJ.4 projection arguments. }

\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\examples{
data(state)
states <- data.frame(state.x77, state.center)
states <- states[states$x > -121,]
coordinates(states) <- c("x", "y")
proj4string(states) <- CoRS("+proj=latlong +datum=NAD27")
states
state.ll83 <- transform(states, CoRS("+proj=latlong +datum=NAD83"))
state.ll83
state.merc <- transform(states, CoRS=CoRS("+proj=merc +datum=WGS84"))
state.merc
state.merc <- transform(states, CoRS=CoRS("+proj=merc +datum=WGS84 +units=us-mi"))
state.merc
data(meuse)
coordinates(meuse) <- c("x", "y")
proj4string(meuse) <- CoRS("+proj=stere +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m")
meuse.utm <- transform(meuse, CoRS("+proj=utm +zone=32 +datum=WGS84"))
cbind(coordinates(meuse), coordinates(meuse.utm))
library(maptools)
x <- read.shape(system.file("shapes/sids.shp", package="maptools")[1])
P4x <- Map2Poly4(x, region.id=x$att.data$FIPSNO, projargs="+proj=latlong +datum=NAD27")
par(mfrow=c(2,2))
plot(P4x)
title(main="latlong, NAD27")
plot(transform(P4x, CoRS("+proj=utm +zone=17 +datum=NAD83")))
title(main="UTM zone 17, NAD83")
plot(transform(P4x, CoRS("+proj=lcc +lat_1=36.16666666666666 +lat_2=34.33333333333334 +lat_0=33.75 +lon_0=-79 +x_0=609601.2192024384 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +units=mi")))
title(main="State Plane North Carolina, NAD83")
par(mfrow=c(1,1))
}

\keyword{methods}
\keyword{spatial}
