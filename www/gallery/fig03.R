library(sp)
library(lattice) # required for trellis.par.set():
trellis.par.set(sp.theme()) # sets color ramp to bpy.colors()

data(meuse)
coordinates(meuse)=~x+y

scale = list("SpatialPolygonsRescale", layout.scale.bar(), 
	offset = c(178600,332990), scale = 500, fill=c("transparent","black"))
text1 = list("sp.text", c(178600,333090), "0")
text2 = list("sp.text", c(179100,333090), "500 m")
arrow = list("SpatialPolygonsRescale", layout.north.arrow(), 
	offset = c(178750,332500), scale = 400)
## points plot with scale bar, scale bar text, north arrow and title:
spplot(meuse, "zinc", do.log=T,
	key.space=list(x=0.1,y=0.93,corner=c(0,1)),
	sp.layout=list(scale,text1,text2,arrow),
	main = "Zinc (top soil)")
