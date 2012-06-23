loadMeuse = function(gridded = TRUE) {
   meuse = NULL
   meuse.grid = NULL
   data(meuse)
   coordinates(meuse) <<- ~x+y
   data(meuse.grid)
   if (gridded) {
     gridded(meuse.grid) <<- ~x+y
  } else 
	 coordinates(meuse.grid) <<- ~x+y
  proj4string(meuse) <<- CRS("+init=epsg:28992")
  proj4string(meuse.grid) <<- CRS("+init=epsg:28992")
  invisible(NULL)
}
