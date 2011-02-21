library(sp)
library(lattice) # required for trellis.par.set():
trellis.par.set(sp.theme()) # sets color ramp to bpy.colors()

alphaChannelSupported = function() { 
	!is.na(match(names(dev.cur()), c("pdf")))
}

data(meuse)
coordinates(meuse)=~x+y
data(meuse.riv)
meuse.sr = SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))
rv = list("sp.polygons", meuse.sr, fill = "lightblue")

scale = list("SpatialPolygonsRescale", layout.scale.bar(), 
	offset = c(180500,329800), scale = 500, fill=c("transparent","black"), which = 4)
text1 = list("sp.text", c(180500,329900), "0", cex = .5, which = 4)
text2 = list("sp.text", c(181000,329900), "500 m", cex = .5, which = 4)
arrow = list("SpatialPolygonsRescale", layout.north.arrow(), 
	offset = c(181300,329800), 
	scale = 400, which = 4)

library(gstat, pos = match(paste("package", "sp", sep=":"), search()) + 1)
data(meuse.grid)
coordinates(meuse.grid) = ~x+y
gridded(meuse.grid) = TRUE
v.ok = variogram(log(zinc)~1, meuse)
ok.model = fit.variogram(v.ok, vgm(1, "Exp", 500, 1))
# plot(v.ok, ok.model, main = "ordinary kriging")
v.uk = variogram(log(zinc)~sqrt(dist), meuse)
uk.model = fit.variogram(v.uk, vgm(1, "Exp", 300, 1))
# plot(v.uk, uk.model, main = "universal kriging")
meuse[["ff"]] = factor(meuse[["ffreq"]])
meuse.grid[["ff"]] = factor(meuse.grid[["ffreq"]])
v.sk = variogram(log(zinc)~ff, meuse)
sk.model = fit.variogram(v.sk, vgm(1, "Exp", 300, 1))
# plot(v.sk, sk.model, main = "stratified kriging")
zn.ok = krige(log(zinc)~1,          meuse, meuse.grid, model = ok.model)
zn.uk = krige(log(zinc)~sqrt(dist), meuse, meuse.grid, model = uk.model)
zn.sk = krige(log(zinc)~ff,         meuse, meuse.grid, model = sk.model)
zn.id = krige(log(zinc)~1,          meuse, meuse.grid)

rv = list("sp.polygons", meuse.sr, 
	fill = ifelse(alphaChannelSupported(), "blue", "transparent"),
	alpha = ifelse(alphaChannelSupported(), 0.1, 1))
pts = list("sp.points", meuse, pch = 3, col = "grey", 
	alpha = ifelse(alphaChannelSupported(), .5, 1))
spplot(zn.uk, "var1.pred",
	sp.layout = list(rv, scale, text1, text2, pts),
	main = "log(zinc); universal kriging using sqrt(dist to Meuse)")
zn.uk[["se"]] = sqrt(zn.uk[["var1.var"]])

## Universal kriging standard errors; grid plot with point locations
## and polygon (river), pdf has transparency on points and river
spplot(zn.uk, "se",
	sp.layout = list(rv, scale, text1, text2, pts),
	main = "log(zinc); universal kriging standard errors")

