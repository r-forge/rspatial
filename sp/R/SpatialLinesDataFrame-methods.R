SpatialLinesDataFrame = function(sl, data) {
	new("SpatialLinesDataFrame", sl, data = data)
}

plot.SpatialLinesDataFrame = function(x, ...) plotSpatialLines(x, ...)

summary.SpatialLinesDataFrame = summary.Spatial

names.SpatialLinesDataFrame = function(x) names(x@data)
