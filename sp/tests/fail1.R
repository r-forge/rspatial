library(sp)
data(meuse)
x = meuse

coordinates(x) <- c("x", "y")
res <- try(proj4string(x) <- 1.5)
print(res)

res <- try(coordinates(a) <- cbind(1:10, 10:1))
print(res)
# fails because a is not found; passes if a assigned NULL, see pass1.R

x = meuse
# invalid coordinate formulae:
res <- try(coordinates(x) <- ~log(x)+sqrt(y)) # no expressions allowed
print(res)
res <- try(coordinates(x) <- ~x+y+z) # z is not present
print(res)
x$x2 = x$x^2
x$y2 = x$y^2
res <- try(coordinates(x) <- ~x+y+x2+y2) # 4D not allowed
print(res)
res <- try(coordinates(x) <- ~x) # 1D not allowed
print(res)
# is.na.sp.coords
a = data.frame(cbind(xx=c(1,NA,2,10),yy=c(2,NA,NA,20)))
res <- try(coordinates(a) <- c("xx", "yy")) # should fail!
print(res)

x = meuse[1:4,]
coordinates(x) = c(1,2)
# this should fail -- zinc is not a row:
#try(q <- x["zinc",])
# this will issue a warning under S-Plus, or a silent rename under R
res <- try(x[c("zinc", "x", "copper", "zinc")])
print(res)

xx = data.frame(x=1:10, y=1:10)
res <- try(coordinates(xx) <- c("x", "y")) 
  #leaves data.frame empty: use SpatialPoints
print(res)
