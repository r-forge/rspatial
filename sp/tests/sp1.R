library(sp)
data(meuse)
nm <- names(meuse)
# rename to non-default names:
nm[1] <- "xcoord"
nm[2] <- "ycoord"
names(meuse) <- nm
# change column order
meuse = meuse[ , c(3:14,2,1)] 
coordinates(meuse) <- c("xcoord", "ycoord") # columns named xcoord and ycoord
coordinates(meuse)[1:10,] 
meuse[1:10,] 
class(meuse)
sum = summary(meuse)
sum
coordinates(meuse)

meuse<-as.data.frame(meuse)
class(meuse)

meuse[1:10, c("xcoord", "ycoord")]

# is.na.sp.coords
a = data.frame(cbind(xx=c(1,NA,2,10),yy=c(2,NA,NA,20)))
try(coordinates(a) <- c("xx", "yy")) # should fail!

data(meuse) # reinit
meuse = meuse[1:4,]
x = SpatialDataFrame(meuse, coord.columns = c(1,2))
# row 1,2; cols 1:10
x[1:2,1:10]
# row 2, coord+col 9,10
x[2,9:10]
# coordinates, col 9+10
x[,9:10]
# coordinates + col 9:
x[,9]
# coordinates + zinc column:
x["zinc"]
# this will fail -- zinc is not a row:
try(q <- x["zinc",])
# second row, coordinates + zinc
x[2,"zinc"]
# ignore x, rename second zinc:
x[c("zinc","copper","x","zinc")]
data.frame(x)
