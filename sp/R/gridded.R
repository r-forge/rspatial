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
		} 
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

griddedfn = function(obj) return (extends(class(obj), "SpatialGrid"))

setMethod("gridded", "Spatial", function(obj) griddedfn(obj))

fullgrid = function(obj) return(is(obj, "SpatialGridDataFrame") && length(obj@grid.index) == 0)

"fullgrid<-" = function(obj, value) {
	if (!is(obj, "SpatialGridDataFrame"))
		stop("fullgrid<- only works on objects of class SpatialGridDataFrame")
	if (fullgrid(obj) == value[1])
		return(obj)
	if (value[1] == TRUE) {
    	fd = obj@data
    	data = list()
    	n = .NumberOfCells(obj@grid)
    	for (i in seq(along=fd)) {
        	if (is.factor(fd[[i]]))
            	stop("cannot (yet) coerce factor variables")
        	else if (is.integer(fd[[i]]))
            	data[[i]] = rep(as.integer(NA), n)
        	else if (is.numeric(fd[[i]]))
            	data[[i]] = rep(as.numeric(NA), n)
    	}
    	data = data.frame(data)
    	names(data) = names(fd)
    	for (i in seq(along=fd))
        	data[obj@grid.index, i] = fd[[i]]
    	obj = SpatialGridDataFrame(grid = obj@grid, data = data, 
			coords.nrs = obj@coords.nrs, proj4string = CRS(proj4string(obj)))
	} else {
		if (length(value) == 2 && value[2] == TRUE)
			sel = apply(obj@data, 1, function(x) !all(is.na(x)))
		else
			sel = TRUE
		if (!any(sel)) {
			warning("complete map seems to be NA's -- no selection was made")
			sel = rep(TRUE, length(sel))
		}
    	obj = SpatialGridDataFrame(coordinates(obj)[sel,,drop=FALSE], 
			data = obj@data[sel,,drop=FALSE], coords.nrs = obj@coords.nrs, 
			proj4string = CRS(proj4string(obj)))
		#warning("in fullgrid(obj)<-FALSE, empty (NA) grid cells were not removed")
	}
	obj
}
