require(spmaptools)
gSRDF <- read_ShapePoly(system.file("shapes/georgia.shp", package="spgwr")[1], proj4string=CRS("+proj=latlong +datum=NAD27"))
