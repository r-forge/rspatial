SpatialLinesDataFrame = function(sl, data) {
	new("SpatialLinesDataFrame", sl, data = data)
}

plot.SpatialLinesDataFrame = function(x, ...) plotSpatialLines(x, ...)

summary.SpatialLinesDataFrame = summary.Spatial

names.SpatialLinesDataFrame = function(x) names(x@data)

as.data.frame.SpatialLinesDataFrame = function(x, row.names, optional) x@data

setAs("SpatialLinesDataFrame", "data.frame", function(from)
    as.data.frame.SpatialLinesDataFrame(from))
