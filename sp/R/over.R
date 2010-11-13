.aggregateAttr = function(lst, fn = NULL, n) {
	if (is.null(fn))
		fn = function(x) { x[1,,drop=FALSE] }
	ix = as.integer(names(lst))
	ret = do.call(rbind, lapply(lst, fn))
	ret[is.nan(ret)] = NA
	#row.names(ret) = levels(r)
	ret[match(1:n, ix),,drop=FALSE]
}

.split = function(df, idx, n) {
	spl = split(df, idx)
	ix = as.integer(names(spl))
	ret = sapply(1:n, function(x) list())
	ret[ix] = spl
	ret
}

.overDF = function(r, data, n, returnList, fn) {
	if (!returnList)
		return(.aggregateAttr(split(data, r), fn, n))
	else 
		stopifnot(is.null(fn))
	.split(data, r, n)
}

overPointsPolygons = function(x, y, returnList = FALSE, fn = NULL) {
	id = pointsInSpatialPolygons(geometry(x), geometry(y))
	if (!is.null(fn)) {
		data.frame(t(data.frame(lapply(split(y@data, id), fn))))
	} else
		id
}

'%ov%' = function(x,y) over(x,y)

setMethod("over",
	signature(x = "SpatialPoints", y = "SpatialPolygons"), 
		function(x, y, returnList = FALSE, fn = NULL)
#			factor(as.factor(overPointsPolygons(x, y)), levels = 1:length(y),
#				labels = names(y))
	pointsInSpatialPolygons(x, y)
)
setMethod("over",
	signature(x = "SpatialPoints", y = "SpatialPolygonsDataFrame"), 
		function(x, y, returnList = FALSE, fn = NULL) {
			r = pointsInSpatialPolygons(x, geometry(y))
			#.overDF(r, y@data, length(x), returnList, fn)
			ret = y@data[r,]
			row.names(ret) = row.names(x)
			ret
		}
)

setMethod("over",
	signature(x = "SpatialPolygons", y = "SpatialPoints"), 
		function(x, y, returnList = FALSE, fn = NULL) {
			r = pointsInSpatialPolygons(geometry(y), geometry(x))
			ret = sapply(1:length(x), function(X) which(X == r))
			if (!returnList)
				ret = unlist(lapply(ret, function(X) X[1]))
        	ret
		}
)
setMethod("over",
	signature(x = "SpatialPolygons", y = "SpatialPointsDataFrame"), 
		function(x, y, returnList = FALSE, fn = NULL) {
			r = over(y, x)
			ret = .overDF(r, y@data, length(x), returnList, fn)
			row.names(ret) = row.names(x)
			ret
		}
)
setMethod("over",
	signature(x = "SpatialPolygons", y = "SpatialGridDataFrame"), 
		function(x, y, returnList = FALSE, fn = NULL) {
			over(x, as(y, "SpatialPixelsDataFrame"), returnList = returnList,
				fn = fn)
		}
)

setMethod("over", signature("SpatialPoints", "SpatialGrid"), 
	function(x, y, returnList = FALSE, fn = NULL) {
		getGridIndex(coordinates(x), y@grid, all.inside = FALSE)
	}
)

setMethod("over", signature("SpatialPoints", "SpatialGridDataFrame"), 
	function(x, y, returnList = FALSE, fn = NULL) {
		#idx = over(geometry(y), x)
		#ret = .overDF(idx, y@data, length(x), returnList, fn)
		#row.names(ret) = row.names(x)
		#ret
		idx = over(x, geometry(y))
		ret = y@data[idx,]
		row.names(ret) = row.names(x)
		ret
	}
)

setMethod("over", signature("SpatialPoints", "SpatialPixels"), 
	function(x, y, returnList = FALSE, fn = NULL) {
		idx = getGridIndex(coordinates(x), y@grid, all.inside = FALSE)
		idx = match(idx, y@grid.index)
		idx
	}
)

setMethod("over", signature("SpatialPoints", "SpatialPixelsDataFrame"), 
	function(x, y, returnList = FALSE, fn = NULL) {
		idx = over(x, geometry(y))
		ret = y@data[idx,]
		row.names(ret) = row.names(x)
		ret
	}
)
