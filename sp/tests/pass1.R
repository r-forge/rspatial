library(sp)
data(meuse)
x = meuse
coordinates(x) = cbind(rnorm(155), rnorm(155))
# should pass:
names(x@data)
x = meuse
# coordinates defined as data:
coordinates(x) = cbind(xcoord = rnorm(155), ycoord = rnorm(155))
# should pass:
names(x@data)
formula(x)
is.projected(x)
proj4string(x)

x = meuse[, sample(NCOL(meuse))] # randomly shuffle columns
# coordinates defined as variable names:
coordinates(x) = c("x", "y") # no matter their position
plot(x, cex=.05*sqrt(x@data[,"zinc"]),xlab="x-coordinate", 
 ylab="y-coordinate", main = "Meuse: zinc bubble plot")
summary(meuse)

# coordinates defined as formula:
x = meuse[, 1:5]
coordinates(meuse) = ~x+y
formula(meuse)
summary(meuse)

a = NULL
cc = cbind(sample(1:10), sample(1:10), sample(1:10))
coordinates(a) = cc
summary(a)
formula(a)
