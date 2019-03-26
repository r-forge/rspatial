library(sp)

## plot for SpatialPolygons, with county name at label point
library(maptools)
nc2 <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +datum=NAD27"))
plot(nc2)
invisible(text(getSpPPolygonsLabptSlots(nc2), labels=as.character(nc2$NAME), cex=0.4))
