setClass("SpatialCellDataFrame",
	representation("SpatialCell", data = "data.frame", coords.nrs = "numeric"),
	validity = function(object) {
		# check nrows in data.frame equal n points
		if (nrow(object@coords) != nrow(object@data))
			stop("unequal number of objects in points and data.frame")
		return(TRUE)
	}
)

SpatialCellDataFrame = function(points, data, coords.nrs = numeric(0)) {
	new("SpatialCellDataFrame", SpatialCell(SpatialPoints(points)), 
		data = data, coords.nrs = coords.nrs)
}

setMethod("coordinates", "SpatialCellDataFrame", 
	function(obj) coordinates(as(obj, "SpatialCell")))

as.matrix.SpatialCellDataFrame = function(x) {
	as.matrix(as(x, "SpatialGriddedDataFrame"))
}

names.SpatialCellDataFrame <- function(x) {
	names(as.data.frame(x))
}

as.data.frame.SpatialCellDataFrame = function(x, row.names, optional) {
	as(x, "data.frame")
}

setIs("SpatialCellDataFrame", "SpatialPointsDataFrame", 
	coerce = function(from) 
		SpatialPointsDataFrame(from@coords, from@data, from@coords.nrs)
)

setIs("SpatialCellDataFrame", "SpatialGridded", coerce = function(from) from@grid)

as.SpatialGriddedDataFrame.SpatialCellDataFrame = function(from)  {
	fd = from@data
	data = list()
	n = .NumberOfCells(from@grid)
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
		data[from@grid.index, i] = fd[[i]]
	SpatialGriddedDataFrame(from@grid, data)
}

setIs("SpatialCellDataFrame", "SpatialGriddedDataFrame", 
	coerce = as.SpatialGriddedDataFrame.SpatialCellDataFrame)

setAs("SpatialCellDataFrame", "data.frame", 
	function(from) as(as(from, "SpatialPointsDataFrame"), "data.frame")
)

as.SpatialCellDataFrame.SpatialGriddedDataFrame = function(from) {
	new("SpatialCellDataFrame", 
		new("SpatialCell", SpatialPoints(coordinates(from)),
			grid = as(from, "SpatialGridded"), 
			grid.index = 1:.NumberOfCells(from)),
		data = from@data, coords.nrs = numeric(0)
	)
}

subset.SpatialCellDataFrame <- function(x, subset, select, drop = FALSE, ...) {
    if (version$major == 2 & version$minor < 1 ) {
	subset.matrix <- function (x, subset, select, drop = FALSE, ...) {
    		if (missing(select)) 
        		vars <- TRUE
    		else {
        		nl <- as.list(1:ncol(x))
        		names(nl) <- colnames(x)
        		vars <- eval(substitute(select), nl, parent.frame())
    		}
    		if (!is.logical(subset)) 
        		stop("'subset' must be logical")
    		x[subset & !is.na(subset), vars, drop = drop]
	}
    }
	xSP <- coordinates(x)
	dfSP <- as.data.frame(x)
	cselect <- colnames(xSP)
	points <- subset(xSP, subset=subset, select=cselect, drop = drop, ...)
	if (missing(select)) select <- names(dfSP)
	data <- subset(dfSP, subset=subset, select=select, drop = drop, ...)
	SCDF <- SpatialCellDataFrame(points, data)
	SCDF
}

"[.SpatialCellDataFrame" <- function(x, i, j, ... , drop = FALSE) {
	n.args = nargs()
	if (!missing(drop))
		stop("don't supply drop: it needs to be FALSE anyway")
	if (missing(i) && missing(j))
		return(x)
	if (missing(j)) {
		if (n.args == 3) # with a , : x[i,]
			res = as(x, "SpatialPointsDataFrame")[i = i, TRUE, ...]
		else # withouth a , : x[i]
			res = as(x, "SpatialPointsDataFrame")[TRUE, j = i, ...]
	} else if (missing(i))
		res = as(x, "SpatialPointsDataFrame")[TRUE, j = j, ...]
	else
		res = as(x, "SpatialPointsDataFrame")[i = i, j = j, ...]
	gridded(res) = TRUE
	res
}

"[[.SpatialCellDataFrame" =  function(x, ...) {
	x@data[[...]]
}

"[[<-.SpatialCellDataFrame" =  function(x, i, j, value) {
	if (!missing(j))
		stop("only valid calls are x[[i]] <- value")
	x@data[[i]] <- value
	x
}

print.SpatialCellDataFrame = function(x, ...) {
	cat("Object of class SpatialCellDataFrame\n")
	print(as(x, "SpatialGridded"))
	print(as(x, "SpatialPointsDataFrame"))
	invisible(x)
}
names.SpatialCellDataFrame = function(x) names(as(x, "SpatialPointsDataFrame"))

print.SpatialGriddedDataFrame = function(x, ...) {
	cat("Object of class SpatialGriddedDataFrame\n")
	print(as(x, "SpatialGridded"))
	# print(as(as(x, "SpatialCellDataFrame"), "SpatialPointsDataFrame"))
	cat("Data:\n")
	print(summary(x@data))
	invisible(x)
}

plot.SpatialCellDataFrame = function(x, ...) {
	plot(as(x, "SpatialPoints"), ...)
}

summary.SpatialCellDataFrame = summary.Spatial

print.summary.SpatialCellDataFrame = print.summary.Spatial
