library(sp)
library(lattice) # required for trellis.par.set():
trellis.par.set(sp.theme()) # sets color ramp to bpy.colors()

data(meuse)
coordinates(meuse)=~x+y

## coloured points plot with legend in plotting area and scales:
spplot(meuse, "zinc", do.log = TRUE,
	key.space=list(x=0.2,y=0.9,corner=c(0,1)),
	scales=list(draw=T))
