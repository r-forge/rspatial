library(sp)
library(lattice)

data(meuse)
coordinates(meuse) = ~x+y

## bubble plots for cadmium and zinc
data(meuse)
coordinates(meuse) <- c("x", "y") # promote to SpatialPointsDataFrame
b1 = bubble(meuse, "cadmium", maxsize = 1.5, main = "cadmium concentrations (ppm)",
	key.entries = 2^(-1:4))
b2 = bubble(meuse, "zinc", maxsize = 1.5, main = "zinc concentrations (ppm)",
	key.entries =  100 * 2^(0:4))
print(b1, split = c(1,1,2,1), more = TRUE)
print(b2, split = c(2,1,2,1), more = FALSE)
