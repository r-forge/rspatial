"gridded<-" = function(obj, value) {
	if (is.logical(value)) {
		if (is(obj, "SpatialGridDataFrame")) {
			if (value == FALSE)
				obj = as(obj, "SpatialPointsDataFrame")
		} else if (is(obj, "SpatialGrid")) {
			if (value == FALSE)
				obj = as(obj, "SpatialPoints")
		} else if (is(obj, "SpatialPointsDataFrame")) {
			if (value == TRUE)
				#obj = as(obj, "SpatialGridDataFrame")
				obj = SpatialGridDataFrame(as(obj, "SpatialPoints"), data = obj@data, 
					coords.nrs = obj@coords.nrs)
		} else if (is(obj, "SpatialPoints")) {
			if (value == TRUE)
				#obj = as(obj, "SpatialGrid")
				obj = SpatialGrid(obj)
		} else
			stop("gridded<- only works for SpatialPoints[DataFrame] or SpatialGrid[DataFrame]")
	} else {
		if (is(value, "formula") || is(value, "character")) {
			if (!is(obj, "data.frame"))
				stop("data.frame expected as object")
			coordinates(obj) = value
			gridded(obj) = TRUE
		} else if (is(value, "GridTopology"))
			return(SpatialGridDataFrame(grid = SpatialGrid(grid = value), data.frame(obj)))
		else
			stop(paste("cannot deal with value of class"), class(value))
		# further deal with more complex forms of value
	}
	obj
}

setMethod("gridded", "Spatial", function(obj) is(obj, "SpatialGrid"))

fullgrid = function(obj) return(is(obj, "SpatialGrid") && length(obj@grid.index) == 0)

"fullgrid<-" = function(obj, value) {
	if (!is(obj, "SpatialGrid"))
		stop("fullgrid<- only works on objects of class or extending SpatialGrid")
	if (fullgrid(obj) == value[1])
		return(obj)
	if (value[1] == TRUE) { # convert to full grid
    	grd = SpatialGrid(grid = obj@grid, proj4string = CRS(proj4string(obj)))
		if (is(obj, "SpatialGridDataFrame")) {
    		fd = obj@data
    		data = list()
    		n = .NumberOfCells(obj@grid)
    		for (i in seq(along=fd)) {
				data[[i]] = vector(mode(fd[[i]]), n)
        		if (is.factor(fd[[i]]))
					data[[i]] = factor(data[[i]], levels = levels(fd[[i]]))
    		}
    		data = data.frame(data)
    		names(data) = names(fd)
    		for (i in seq(along=fd)) {
        		data[obj@grid.index, i] = fd[[i]]
        		data[-obj@grid.index, i] = NA
			}
			obj = SpatialGridDataFrame(grid = grd@grid, data = data, 
				coords.nrs = obj@coords.nrs, proj4string = CRS(proj4string(obj)))
		} else
    		obj = SpatialGrid(grid = obj@grid, proj4string = CRS(proj4string(obj)))
	} else {
		if (!is(obj, "SpatialGridDataFrame"))
			stop("fullgrid(obj) <- FALSE only works for SpatialGridDataFrame")
		if (length(value) == 2 && value[2] == TRUE)
			sel = apply(obj@data, 1, function(x) !all(is.na(x)))
		else
			sel = TRUE
		if (!any(sel)) {
			warning("complete map seems to be NA's -- no selection was made")
			sel = rep(TRUE, length(sel))
		}
    	obj = SpatialGridDataFrame(points = coordinates(obj)[sel,,drop=FALSE], 
			data = obj@data[sel,,drop=FALSE], coords.nrs = obj@coords.nrs, 
			proj4string = CRS(proj4string(obj)))
	}
}
