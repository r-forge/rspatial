library(sp)
library(lattice) # required for trellis.par.set():
trellis.par.set(sp.theme()) # sets color ramp to bpy.colors()

data(meuse)
coordinates(meuse)=~x+y
data(meuse.riv)
meuse.sr = SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))
rv = list("sp.polygons", meuse.sr, fill = "lightblue")

## multi-panel plot, scales + north arrow only in last plot:
## using the "which" argument in a layout component
## (if which=4 was set as list component of sp.layout, the river
## would as well be drawn only in that (last) panel)
scale = list("SpatialPolygonsRescale", layout.scale.bar(), 
	offset = c(180500,329800), scale = 500, fill=c("transparent","black"), which = 4)
text1 = list("sp.text", c(180500,329900), "0", cex = .5, which = 4)
text2 = list("sp.text", c(181000,329900), "500 m", cex = .5, which = 4)
arrow = list("SpatialPolygonsRescale", layout.north.arrow(), 
	offset = c(181300,329800), 
	scale = 400, which = 4)
cuts = c(.2,.5,1,2,5,10,20,50,100,200,500,1000,2000)
spplot(meuse, c("cadmium", "copper", "lead", "zinc"), do.log = TRUE,
	key.space = "right", as.table = TRUE,
	sp.layout=list(rv, scale, text1, text2, arrow), # note that rv is up front!
	main = "Heavy metals (top soil), ppm", cex = .7, cuts = cuts)
