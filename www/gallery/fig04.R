library(sp)
library(lattice) # required for trellis.par.set():
trellis.par.set(sp.theme()) # sets color ramp to bpy.colors()

data(meuse)
coordinates(meuse)=~x+y
data(meuse.riv)
meuse.sr = SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))
rv = list("sp.polygons", meuse.sr, fill = "lightblue")

scale = list("SpatialPolygonsRescale", layout.scale.bar(), 
	offset = c(180500,329800), scale = 500, fill=c("transparent","black"), which = 1)
text1 = list("sp.text", c(180500,329900), "0", which = 1)
text2 = list("sp.text", c(181000,329900), "500 m", which = 1)
arrow = list("SpatialPolygonsRescale", layout.north.arrow(), 
	offset = c(178750,332500), scale = 400)
## plot with north arrow and text outside panels
## (scale can, as of yet, not be plotted outside panels)
spplot(meuse["zinc"], do.log = TRUE,
	key.space = "bottom", 
	sp.layout = list(rv, scale, text1, text2),
	main = "Zinc (top soil)",
	legend = list(right = list(fun = mapLegendGrob(layout.north.arrow()))))
