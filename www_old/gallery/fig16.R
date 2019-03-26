library(sp)
data(meuse.riv)

meuse.sr = SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)), "x")))
plot(meuse.sr)
## stratified sampling within a polygon
points(spsample(meuse.sr@polygons[[1]], n = 200, "stratified"), pch = 3, cex=.3)
