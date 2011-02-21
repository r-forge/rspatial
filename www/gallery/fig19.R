## nonaligned systematic sampling over a grid
library(sp)
data(meuse.grid)
gridded(meuse.grid) = ~x+y
image(meuse.grid["dist"])
points(spsample(meuse.grid,n=1000,type="nonaligned"), pch=3, cex=.4)
