setClass("SpatialGriddedDataFrame", 
	representation("SpatialGridded", data = "data.frame"),
	validity = function(object) {
		if (.NumberOfCells(object) != nrow(object@data))
			stop("nr of cells in grid does not equal nr of rows in data")
		return(TRUE)
	}
)

SpatialGriddedDataFrame = function(grid, data) {
	new("SpatialGriddedDataFrame", grid, data = data)
}

setMethod("coordinates", "SpatialGriddedDataFrame", 
	function(obj) coordinates(as(obj, "SpatialGridded")))

as.matrix.SpatialGriddedDataFrame = function(x) {
	if (ncol(x@data) > 1)
		warning("as.matrix.SpatialGriddedDataFrame uses first column;\n pass subset or [] for other columns")
	matrix(x@data[[1]], x@cells.dim[1], x@cells.dim[2], byrow=FALSE)
}

as.data.frame.SpatialGriddedDataFrame <- function(x, row.names = NULL, 
	optional = FALSE) {
	as.data.frame(as(x, "SpatialCellDataFrame"), row.names = row.names, optional = optional)
}

print.SpatialGriddedDataFrame = function(x, ...) {
	cat("Object of class SpatialGriddedDataFrame\n")
	print(as(x, "SpatialGridded"))
	# print(as(as(x, "SpatialCellDataFrame"), "SpatialPointsDataFrame"))
	cat("Data:\n")
	print(summary(x@data))
	invisible(x)
}


"[.SpatialGriddedDataFrame" =  function(x, i, j, ..., drop = F) {
	if (!missing(drop))
		stop("don't supply drop: it needs to be FALSE anyway")
	n.args = nargs()
	if (missing(i) && missing(j))
		return(x)
	if (missing(j)) {
		if (n.args == 3) # with a , : x[i,]
			stop("row selection not implemented for this class")
		else # withouth a , : x[i]
			x@data = x@data[TRUE, j = i, ..., drop = FALSE]
	} else if (missing(i))
		x@data = x@data[TRUE, j = j, ...]
	else
		stop("row selection not implemented for this class")
	x
}

"[[.SpatialGriddedDataFrame" =  function(x, ...) {
	x@data[[...]]
}

"[[<-.SpatialGriddedDataFrame" =  function(x, i, j, value) {
	if (!missing(j))
		stop("only valid calls are x[[i]] <- value")
	x@data[[i]] <- value
	x
}

summary.SpatialGriddedDataFrame = summary.Spatial

print.summary.SpatialGriddedDataFrame = print.summary.Spatial
