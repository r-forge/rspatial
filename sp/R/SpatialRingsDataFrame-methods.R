SpatialRingsDataFrame <- function(Sr, data, labelPoints) {
	if (missing(labelPoints))
		new("SpatialRingsDataFrame", Sr, data = data)
	else
		new("SpatialRingsDataFrame", Sr, data = data, labelPoints = labelPoints)
}
