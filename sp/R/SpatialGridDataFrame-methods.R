SpatialGridDataFrame = function(points = NULL, grid = NULL, data, 
		coords.nrs = numeric(0), proj4string = CRS(as.character(NA))) {
	if (!is.null(points)) {
		if (is(points, "SpatialPoints"))
			points = SpatialGrid(SpatialPoints(points, CRS(proj4string(points))))
		else
			points = SpatialGrid(SpatialPoints(points))
		new("SpatialGridDataFrame", points, data = data, coords.nrs = coords.nrs)
	} else
		new("SpatialGridDataFrame", SpatialGrid(grid = grid, proj4string=proj4string), 
			data = data, coords.nrs = coords.nrs)
}

setMethod("coordinates", "SpatialGridDataFrame", 
	function(obj) coordinates(as(obj, "SpatialGrid")))

setIs("SpatialGridDataFrame", "SpatialPointsDataFrame",
	coerce = function(from) { 
		fullgrid(from) = FALSE
		new("SpatialPointsDataFrame",
			as(from, "SpatialPoints"), data = from@data, coords.nrs = from@coords.nrs)
	}, replace = function(obj, value) stop("no replace function for this coercion")
)

as.matrix.SpatialGridDataFrame = function(x) {
	if (ncol(x@data) > 1)
		warning(
		"as.matrix.SpatialGriddedDataFrame uses first column;\n pass subset or [] for other columns")
	fullgrid(x) = TRUE
	matrix(x@data[[1]], x@grid@cells.dim[1], x@grid@cells.dim[2], byrow=FALSE)
}

setAs("SpatialGridDataFrame", "matrix", function(from) as.matrix.SpatialGridDataFrame(from))

names.SpatialGridDataFrame = function(x) {
	names(as.data.frame(x))
}

as.data.frame.SpatialGridDataFrame = function(x, row.names, optional)
	as.data.frame(as(x, "SpatialPointsDataFrame"))

setAs("SpatialGridDataFrame", "data.frame", function(from) as.data.frame.SpatialGridDataFrame(from))

subset.SpatialGridDataFrame <- function(x, subset, select, drop = FALSE, ...) {
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

subs.SpatialGridDataFrame <- function(x, i, j, ... , drop = FALSE) {
	n.args = nargs()
	if (!missing(drop))
		stop("don't supply drop: it needs to be FALSE anyway")
	if (missing(i) && missing(j))
		return(x)
	if (missing(j)) {
		if (n.args == 3) # with a , : x[i,]
			res = as(x, "SpatialPointsDataFrame")[i = i, TRUE, ...]
		else { # withouth a , : x[i] --- column selection
			#res = as(x, "SpatialPointsDataFrame")[TRUE, j = i, ...]
			res = x
			res@data = res@data[TRUE, j = i, ..., drop = drop]
		}
	} else if (missing(i))
		res = as(x, "SpatialPointsDataFrame")[TRUE, j = j, ...]
	else
		res = as(x, "SpatialPointsDataFrame")[i = i, j = j, ...]
	gridded(res) = TRUE
	res
}
setMethod("[", "SpatialGridDataFrame", subs.SpatialGridDataFrame)
#"[.SpatialGridDataFrame" <- subs.SpatialGridDataFrame

dsubs.SpatialGridDataFrame =  function(x, ...) x@data[[...]]
#setMethod("[[", "SpatialGridDataFrame", dsubs.SpatialGridDataFrame)
"[[.SpatialGridDataFrame" =  dsubs.SpatialGridDataFrame

dsubsass.SpatialGridDataFrame =  function(x, i, j, value) {
	if (!missing(j))
		stop("only valid calls are x[[i]] <- value")
	x@data[[i]] <- value
	x
}
"[[<-.SpatialGridDataFrame" =  dsubsass.SpatialGridDataFrame
#setMethod("[[<-", "SpatialGridDataFrame", dsubsass.SpatialGridDataFrame)

names.SpatialGridDataFrame = function(x) names(as(x, "SpatialPointsDataFrame"))

print.SpatialGridDataFrame = function(x, ...) {
	cat("Object of class SpatialGridDataFrame\n")
	print(as(x, "SpatialGrid"))
	# print(as(as(x, "SpatialCellDataFrame"), "SpatialPointsDataFrame"))
	cat("Full grid:")
	print(length(x@grid.index) == 0)
	cat("\n")
	cat("Data:\n")
	print(summary(x@data))
	invisible(x)
}
#setMethod("show", "SpatialGridDataFrame", print.SpatialGridDataFrame)

plot.SpatialGridDataFrame = function(x, ...)
	plot(as(x, "SpatialPoints"), ...)

summary.SpatialGridDataFrame = summary.Spatial

print.summary.SpatialGridDataFrame = print.summary.Spatial
