\name{aggregate}
\docType{methods}
\alias{aggregate}
\alias{aggregate.Spatial}

\title{ aggregation of spatial objects }
\description{ spatial aggregation of thematic information in spatial objects}
\usage{
\method{aggregate}{Spatial}(x, by, FUN = mean, \dots, dissolve = TRUE)
}
\arguments{
\item{x}{object deriving from \link{Spatial}, with attributes }
\item{by}{ aggregation predicate; if \code{by} is a \link{Spatial} object,
the geometry over which attributes in \code{x} are aggregated; if \code{by}
is a list, aggregation by attribute(s), see \link{aggregate.data.frame}}
\item{FUN}{aggregation function }
\item{...}{arguments passed on to function \code{FUN}}
\item{dissolve}{logical; should, when aggregating based on attributes, the
resulting geometries be dissolved? Note that if \code{x} has class
\code{SpatialPointsDataFrame}, this is not possible}
}
\value{ 
Function aggregate.Spatial aggregates the attribute values of
\code{x} either over the geometry of \code{by} by using \link{over} for
spatial matching, or by attribute values, using aggregation function 
\code{FUN}.
}

\author{Edzer Pebesma, \email{edzer.pebesma@uni-muenster.de}}

\note{ uses \link{over} to find spatial match if \code{by} is a 
\link{Spatial} object }

\examples{
data("meuse")
coordinates(meuse) <- ~x+y
data("meuse.grid")
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE
# aggregation by spatial object:
if (require(rgeos)) {
	ab = gUnaryUnion(as(meuse.grid, "SpatialPolygons"), meuse.grid$part.a)
	x = aggregate(meuse["zinc"], ab, mean)
	spplot(x)
}

# aggregation by attribute:
i = cut(meuse.grid$dist, c(0,.25,.5,.75,1), include.lowest = TRUE)
x = aggregate(meuse.grid["dist"], list(i=i))
spplot(x["i"])
j = sample(1:2, 3103,replace=TRUE)
x = aggregate(meuse.grid["dist"], list(i=i,j=j))
spplot(x["dist"], col.regions=bpy.colors())
spplot(x["i"], col.regions=bpy.colors(4))
spplot(x["j"], col.regions=bpy.colors())
x = aggregate(meuse.grid["dist"], list(i=i,j=j),dissolve=FALSE)
spplot(x["j"], col.regions=bpy.colors())
}
\keyword{methods}
