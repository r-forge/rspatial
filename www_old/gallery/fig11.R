library(sp)

data(meuse.grid)
coordinates(meuse.grid) = ~x+y
gridded(meuse.grid) = TRUE
data(meuse)
coordinates(meuse) = ~x+y
data(meuse.riv)
meuse.sl = SpatialLines(list(Lines(list(Line(meuse.riv)), ID="1")))

## image plot with points and lines
image(meuse.grid["dist"], 
	main = "meuse river data set; colour indicates distance to river")
points(meuse, pch = 3)
lines(meuse.sl)
