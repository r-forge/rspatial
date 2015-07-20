library(sp)
library(ggmap)
demo(meuse, ask=F)
merc = CRS("+init=epsg:3857")
WGS84 = CRS("+init=epsg:4326")

meuse = spTransform(meuse, WGS84)

bgMap = get_map(as.vector(bbox(meuse)), source = "google", zoom = 13) # needs zoom level
plot(spTransform(meuse, merc), bgMap = bgMap, pch = 16, cex = .5) # needs mercator for plotting

# spplot with ggmap bg:
panel.ggmap <- function(map) {
	bb = sp:::bb2merc(map, "ggmap")
	grid::grid.raster(map, mean(bb[1,]), mean(bb[2,]), diff(bb[1,]), diff(bb[2,]), 
		default.units = "native", interpolate = FALSE)
}
spplot(spTransform(meuse, merc), c("zinc",  "lead"), colorkey = TRUE,
	sp.layout = list(panel.ggmap, bgMap, first = TRUE))

bb = t(apply(bbox(meuse), 1, bbexpand, .04))
bgMap = get_map(as.vector(bb), source = "osm") # WGS84 for background map
plot(spTransform(meuse, merc), bgMap = bgMap, pch = 16, cex = .5) # needs mercator for plotting


# RgoogleMaps:
center = apply(coordinates(meuse), 2, mean)[2:1]
library(RgoogleMaps)
g = GetMap(center=center, zoom=13)
par(mar = rep(0,4)) # fill full device
plot(spTransform(meuse, merc), bgMap = g, pch = 16, cex = .5) # needs mercator for plotting

panel.RgoogleMaps <- function(map) {
	bb = sp:::bb2merc(map, "RgoogleMaps")
	grid::grid.raster(map$myTile, mean(bb[1,]), mean(bb[2,]), diff(bb[1,]), diff(bb[2,]), 
		default.units = "native", interpolate = FALSE)
}
spplot(spTransform(meuse, merc), c("zinc",  "lead"),
	sp.layout = list(panel.RgoogleMaps, g, first = TRUE))

# Norway boundary example:
library(cshapes)
cshp = cshp(as.Date("2000-01-1"))
no = cshp[cshp$ISO1AL2 == "NO",]

bgMap = get_map(as.vector(bbox(no))) # WGS84
plot(spTransform(no, merc), bgMap = bgMap, border = 'red')
