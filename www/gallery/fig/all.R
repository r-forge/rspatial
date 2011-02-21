postscript("fig21.ps" , width=8, height=8, onefile=FALSE, paper="special" )
library(sp)
library(maptools)

nc <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +datum=NAD27"))
names(nc)
# create two dummy factor variables, with equal labels:
set.seed(31)
nc$f = factor(sample(1:5,100,replace=T),labels=letters[1:5])
nc$g = factor(sample(1:5,100,replace=T),labels=letters[1:5])
library(RColorBrewer)
## Two (dummy) factor variables shown with qualitative colour ramp; degrees in axes
spplot(nc, c("f","g"), col.regions=brewer.pal(5, "Set3"), scales=list(draw = TRUE))
