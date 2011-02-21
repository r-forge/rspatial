library(sp)
library(lattice) # required for trellis.par.set():
trellis.par.set(sp.theme()) # sets color ramp to bpy.colors()

data(meuse)
coordinates(meuse)=~x+y
data(meuse.riv)
meuse.sr = SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))

## same plot; north arrow now inside panel, custom panel function instead of sp.layout
spplot(meuse, "zinc", panel = function(x, y, ...) {
		sp.polygons(meuse.sr, fill = "lightblue")
		SpatialPolygonsRescale(layout.scale.bar(), offset = c(179900,329600), 
			scale = 500, fill=c("transparent","black"))
		sp.text(c(179900,329700), "0")
		sp.text(c(180400,329700), "500 m")
		SpatialPolygonsRescale(layout.north.arrow(), 
			offset = c(178750,332500), scale = 400)
		panel.pointsplot(x, y, ...)
	},
	do.log = TRUE, cuts = 7,
	key.space = list(x = 0.1, y = 0.93, corner = c(0,1)),
	main = "Top soil zinc concentration (ppm)")
