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

rv = list("sp.polygons", meuse.sr, 
	fill = ifelse(alphaChannelSupported(), "blue", "transparent"),
	alpha = ifelse(alphaChannelSupported(), 0.1, 1))
pts = list("sp.points", meuse, pch = 3, col = "grey", 
	alpha = ifelse(alphaChannelSupported(), .5, 1))
text1 = list("sp.text", c(180500,329900), "0", cex = .5, which = 4)
text2 = list("sp.text", c(181000,329900), "500 m", cex = .5, which = 4)
scale = list("SpatialPolygonsRescale", layout.scale.bar(), 
	offset = c(180500,329800), scale = 500, fill=c("transparent","black"), which = 4)

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

zn = zn.ok
zn[["a"]] = zn.ok[["var1.pred"]]
zn[["b"]] = zn.uk[["var1.pred"]]
zn[["c"]] = zn.sk[["var1.pred"]]
zn[["d"]] = zn.id[["var1.pred"]]
spplot(zn, c("a", "b", "c", "d"), 
	names.attr = c("ordinary kriging", "universal kriging with dist to river", 
		"stratified kriging with flood freq", "inverse distance"), 
	as.table = TRUE, main = "log-zinc interpolation",
	sp.layout = list(rv, scale, text1, text2)
)
