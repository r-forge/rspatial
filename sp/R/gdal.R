read.gdal = function(fname, ..., silent = FALSE) {
	if (!require(rgdal))
		stop("read.gdal needs package rgdal to be properly installed")
	x = GDAL.open(fname)
	d = dim(x)
	if (!silent) {
		cat(paste(fname, "has GDAL driver", getDriverName(getDriver(x)),"\n"))
		cat(paste("and has", d[1], "rows and", d[2], "columns\n"))
	}
	gt = .Call('RGDAL_GetGeoTransform', x, PACKAGE="rgdal")
	# [1] 178400     40      0 334000      0    -40
	if (any(gt[c(3,5)] != 0.0)) {
		data = getRasterTable(x, ...)
		coordinates(data) = c(1,2)
	} else {
		data = getRasterData(x, ...)
		d = dim(data) # rows=nx, cols=ny
		cellsize = abs(c(gt[2],gt[6]))
		cells.dim = c(d[1], d[2]) # c(d[2],d[1])
		cellcentre.offset = c(x = gt[1] + 0.5 * cellsize[1], 
			y = gt[4] - (d[2] - 0.5) * abs(cellsize[2]))
		grid = GridTopology(cellcentre.offset, cellsize, cells.dim)
		if (length(d) == 2)
			df = data.frame(band1 = as.vector(data))
		else {
			df = as.vector(data[,,1])
			for (band in 2:d[3])
				df = cbind(df, as.vector(data[,,band]))
			df = as.data.frame(df)
			names(df) = paste("band", 1:d[3], sep="")
		}
		data = SpatialGridDataFrame(grid = grid, data = df)
	}
	GDAL.close(x)
	return(data)
}

#write.gdal = function(dataset, ...) {
#	stop("write.gdal is not working (yet>")
#}
