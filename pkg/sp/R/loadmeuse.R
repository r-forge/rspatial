loadMeuse = function(gridded = TRUE, river = FALSE) {
   crs = CRS("+init=epsg:28992 +proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.417,50.3319,465.552,-0.398957,0.343988,-1.8774,4.0725 +units=m +no_defs")
   meuse = NULL
   meuse.grid = NULL
   meuse.riv = NULL
   data(meuse)
   coordinates(meuse) <<- ~x+y
   data(meuse.grid)
   if (gridded) {
     gridded(meuse.grid) <<- ~x+y
  } else 
	 coordinates(meuse.grid) <<- ~x+y
  if (river) {
	rm(meuse.riv)
    data(meuse.riv)
    meuse.riv <<- SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))
    proj4string(meuse.riv) <<- crs
  }
  proj4string(meuse) <<- crs
  proj4string(meuse.grid) <<- crs
  invisible(NULL)
}
