# should pass:
library(sp)
x = data.frame(x = c(1,2,3), y = c(4,5,6))
pol1 = cbind(x=c(1,1,2,1),y=c(1,2,1,1)) # closed
polygon.valid = list(pol1, pol1, pol1)
polygons(x) = polygon.valid

as.data.frame(x)

polygons(x)

pol1 = cbind(c(1,1,2,2),c(1,2,3,4)) # open
polygon.invalid = list(pol1, pol1, pol1)
x = data.frame(x = c(1,2,3), y = c(4,5,6))

# should fail:
try(polygons(x) <- polygon.invalid)

# polygon data without attributes:
x = NULL
polygons(x) = polygon.valid
x
summary(x)
