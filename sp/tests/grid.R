library(sp)
data(meuse.grid)
x = meuse.grid
coordinates(x) = c("x", "y")
gridded(x) = TRUE

df = data.frame(z = c(1:6,NA,8,9), 
	xc = c(1,1,1,2,2,2,3,3,3), 
	yc = c(rep(c(0, 1.5, 3),3)))
coordinates(df) = ~xc+yc
gridded(df) = TRUE
#df@data
as.data.frame(df)
print(summary(df))
#as.image.SpatialCellDataFrame(df)
