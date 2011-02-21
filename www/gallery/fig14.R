library(sp)

## plot of SpatialPolygonsDataFrame, using grey shades
library(maptools)
nc1 <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +datum=NAD27"))
names(nc1)
rrt <- nc1$SID74/nc1$BIR74
brks <- quantile(rrt, seq(0,1,1/7))
cols <- grey((length(brks):2)/length(brks))
dens <- (2:length(brks))*3
plot(nc1, col=cols[findInterval(rrt, brks, all.inside=TRUE)])
