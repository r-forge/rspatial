library(sp)
data(meuse)
x = meuse
try(coordinates(x) <- cbind(x = rnorm(155), y = rnorm(155)))
# should fail because "x" and "y" are already present

coordinates(x) <- c("x", "y")
try(proj4string(x) <- 1.5)

try(coordinates(a) <- cbind(1:10, 10:1))
# fails because a is not found; passes if a assigned NULL, see pass1.R

x = meuse
# invalid coordinate formulae:
try(coordinates(x) <- ~log(x)+sqrt(y)) # no expressions allowed
try(coordinates(x) <- ~x+y+z) # z is not present
x$x2 = x$x^2
x$y2 = x$y^2
try(coordinates(x) <- ~x+y+x2+y2) # 4D not allowed
try(coordinates(x) <- ~x) # 1D not allowed
