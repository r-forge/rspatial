"SpatialPointsDataFrame" = function(coords, data, coords.nrs = numeric(0), 
		proj4string = CRS(as.character(NA)), match.ID = TRUE,
                bbox=NULL) {
    if (is.character(match.ID)) {
        row.names(data) = data[match.ID[1]]
        match.ID = TRUE
    }
	if (!is(coords, "SpatialPoints"))
		coords = coordinates(coords)
	if (match.ID && is.matrix(coords)) {
		cc.ID = dimnames(coords)[[1]]
		if (!is.null(cc.ID) && is(data, "data.frame")) { # match ID:
			n = nrow(data)
			if (length(unique(cc.ID)) != n)
				stop(
				"nr of unique coords ID's (rownames) not equal to nr of data records")
			data.ID = row.names(data)
			mtch = match(cc.ID, data.ID)
			if (any(is.na(mtch)))
				stop("row.names of data and coords do not match")
			if (length(unique(mtch)) != n)
				stop("row.names of data and dimnames of coords do not match")
			data = data[mtch, , drop = FALSE]
		}
	}
	if (!is(coords, "SpatialPoints"))
		coords = SpatialPoints(coords, proj4string = proj4string, 
			bbox=bbox)
	new("SpatialPointsDataFrame", coords, data = data, coords.nrs = coords.nrs)
}

setMethod("coordinates", "SpatialPointsDataFrame", function(obj) obj@coords)
setMethod("addAttrToGeom", signature(x = "SpatialPoints", y = "data.frame"),
	function(x, y, match.ID, ...) 
		SpatialPointsDataFrame(x, y, match.ID = match.ID, ...)
)

#setReplaceMethod("coordinates", signature(object = "data.frame", value = "numeric"),
#	coordinates.num)
#coordinates.repl = function(object, value) {

setReplaceMethod("coordinates", signature(object = "data.frame", value = "ANY"),
  function(object, value) {
	coord.numbers = NULL
	#if (!is.list(object))
	#	stop("coordinates can only be set on objects of class data.frame or list")
	if (inherits(value, "formula")) {
		cc = model.frame(value, object) # retrieve coords
		if (dim(cc)[2] == 2) {
			nm = as.character(as.list(value)[[2]])[2:3]
			coord.numbers = match(nm, names(object))
		} else if (dim(cc)[2] == 3) {
			nm = c(as.character(as.list((as.list(value)[[2]])[2])[[1]])[2:3],
				as.character(as.list(value)[[2]])[3])
			coord.numbers = match(nm, names(object))
		} # else: give up.
	} else if (is.character(value)) {
		cc = object[, value] # retrieve coords
		coord.numbers = match(value, names(object))
	} else if (is.null(dim(value)) && length(value) > 1) { # coord.columns?
		if (any(value != as.integer(value) || any(value < 1)))
			stop("coordinate columns should be positive integers")
		cc = object[, value] # retrieve coords
		coord.numbers = value
	} else  # raw coordinates given; try transform them to matrix:
		cc = coordinates(value)
	if (any(is.na(cc)))
		stop("coordinates are not allowed to contain missing values")
	if (!is.null(coord.numbers)) {
		object = object[ , -coord.numbers, drop = FALSE]
		stripped = coord.numbers
		# ... but as.data.frame(x) will merge them back in, so nothing gets lost.
		if (ncol(object) == 0)
			#stop("only coords columns present: use SpatialPoints to create a points object")
			return(SpatialPoints(cc))
	} else
		stripped = numeric(0)
	SpatialPointsDataFrame(coords = cc, data = object, coords.nrs = stripped,
		match.ID = FALSE)
  }
)

.asWKT = FALSE
print.SpatialPointsDataFrame = function(x, ..., digits = 6, asWKT = .asWKT) {
	#EJP, Fri May 21 12:40:59 CEST 2010
	if (asWKT)
		df = data.frame(asWKTSpatialPoints(x, digits), x@data)
	else { # old style
		cc = substring(paste(as.data.frame(
			t(signif(coordinates(x), digits)))),2,999)
		df = data.frame("coordinates" = cc, x@data)
	}
	row.names(df) = row.names(x@data)
	print(df, ...)
}

dim.SpatialPointsDataFrame = function(x) dim(x@data)

as.data.frame.SpatialPointsDataFrame = function(x, ...)  {
	if (length(x@coords.nrs) > 0) {
		maxi = max(x@coords.nrs, (ncol(x@data) + ncol(x@coords)))
		ret = list()
		for (i in 1:ncol(x@coords))
			ret[[x@coords.nrs[i]]] = x@coords[,i]
		names(ret)[x@coords.nrs] = dimnames(x@coords)[[2]]
		idx.new = (1:maxi)[-(x@coords.nrs)]
		for (i in 1:ncol(x@data))
			ret[[idx.new[i]]] = x@data[,i]
		names(ret)[idx.new] = names(x@data)
		ret = ret[unlist(lapply(ret, function(x) !is.null(x)))]
		data.frame(ret)
	} else
		data.frame(x@data, x@coords)
}

setAs("SpatialPointsDataFrame", "data.frame", function(from)
	as.data.frame.SpatialPointsDataFrame(from))

#setAs("SpatialPointsDataFrame", "AttributeList", function(from) from@data)

names.SpatialPointsDataFrame <- function(x) names(x@data)
"names<-.SpatialPointsDataFrame" <- function(x, value) { 
	names(x@data) = value; 
	x 
}

#"coordnames<-.SpatialPointsDataFrame" <- function(x, value)

ShowSpatialPointsDataFrame = function(object) print.SpatialPointsDataFrame(object)
setMethod("show", "SpatialPointsDataFrame", ShowSpatialPointsDataFrame)

points.SpatialPointsDataFrame = function(x, y = NULL, ...) 
	points(as(x, "SpatialPoints"), ...)

text.SpatialPointsDataFrame = function(x, ...) {
    lst = list(x = coordinates(x), ...)
    if (!is.null(x$pos) && is.null(lst$pos))
        lst$pos = x$pos
    if (!is.null(x$offset) && is.null(lst$offset))
        lst$offset = x$offset
    if (!is.null(x$labels) && is.null(lst$labels))
        lst$labels = parse(text = x$lab)
    do.call(text, lst)
}

subset.SpatialPointsDataFrame <- function(x, subset, select, 
		drop = FALSE, ...) {
	xSP <- coordinates(x)
	dfSP <- as.data.frame(x)
	cselect <- colnames(xSP)
	points <- subset(xSP, subset=subset, select=cselect, drop = drop, ...)
	if (missing(select)) select <- names(dfSP)
	data <- subset(dfSP, subset=subset, select=select, drop = drop, ...)
	SPDF <- SpatialPointsDataFrame(points, data, 
		proj4string = CRS(proj4string(x)))
	SPDF
}

row.names.SpatialPointsDataFrame <- function(x) {
    dimnames(slot(x, "coords"))[[1]]
}

"row.names<-.SpatialPointsDataFrame" <- function(x, value) {
    dimnames(slot(x, "coords"))[[1]] <- value
    #coords = (slot(x, "coords"))
    #dimnames(coords)[[1]] <- value
	#x@coords = coords
	x
}

setMethod("[", "SpatialPointsDataFrame", function(x, i, j, ..., drop = TRUE) {
	missing.i = missing(i)
	missing.j = missing(j)
	nargs = nargs() # e.g., a[3,] gives 2 for nargs, a[3] gives 1.
	if (missing.i && missing.j) {
		i = TRUE
		j = TRUE
	} else if (missing.j && !missing.i) { 
		if (nargs == 2) {
			j = i
			i = TRUE
		} else {
			j = TRUE
		}
	} else if (missing.i && !missing.j)
		i = TRUE
	if (is.matrix(i))
		stop("matrix argument not supported in SpatialPointsDataFrame selection")
	if (is(i, "Spatial"))
		i = !is.na(over(x, geometry(i)))
	if (any(is.na(i))) 
		stop("NAs not permitted in row index")
	#coords.nrs = x@coords.nrs
	if (!isTRUE(j)) # i.e., we do some sort of column selection
		x@coords.nrs = numeric(0) # will move coordinate colums last
#	SpatialPointsDataFrame(coords = x@coords[i, , drop = FALSE],
#		data = x@data[i, j, drop = FALSE], 
#		coords.nrs = coords.nrs, 
#		proj4string = CRS(proj4string(x)), 
#		match.ID = FALSE)
	x@coords = x@coords[i, , drop = FALSE]
	x@bbox = .bboxCoords(x@coords)
	x@data = x@data[i, j, ..., drop = FALSE]
	x
})

setMethod("split", "SpatialPointsDataFrame", split.data.frame)

setMethod("geometry", "SpatialPointsDataFrame",
	function(obj) as(obj, "SpatialPoints"))

length.SpatialPointsDataFrame = function(x) { nrow(x@coords) }