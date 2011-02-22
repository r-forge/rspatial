"SpatialPoints" = function(coords, proj4string = CRS(as.character(NA)),
        bbox=NULL) {
	coords = coordinates(coords) # checks numeric mode
	colNames = dimnames(coords)[[2]]
	if (is.null(colNames))
		colNames = paste("coords.x", 1:(dim(coords)[2]), sep = "")
	rowNames = dimnames(coords)[[1]]
	dimnames(coords) = list(rowNames, colNames) # preserve row names if non-NULL
	if (is.null(bbox)) 
		bbox <- .bboxCoords(coords)
	new("SpatialPoints", coords = coords, bbox = bbox,
		proj4string = proj4string) # transpose bbox?
}

.bboxCoords = function(coords) {
	bbox = t(apply(coords, 2, range))
	dimnames(bbox)[[2]] = c("min", "max")
	as.matrix(bbox)
}

.checkNumericCoerce2double = function(obj) {
	if (any(!unlist(lapply(obj, is.numeric))))
		stop("cannot retrieve coordinates from non-numeric elements")
	#lapply(obj, function(x) { if(!is.numeric(x)) 
	#	stop("cannot retrieve coordinates from non-numeric elements") })
	lapply(obj, as.double)
}

setMethod("coordinates", "list", function(obj)
		do.call("cbind", .checkNumericCoerce2double(as.data.frame(obj))))
setMethod("coordinates", "data.frame", function(obj)
		do.call("cbind", .checkNumericCoerce2double(obj)))
setMethod("coordinates", "matrix", 
	function(obj) {
		if (!is.numeric(obj))
			stop("cannot derive coordinates from non-numeric matrix")
		dn = dimnames(obj)
		dd = dim(obj)
#		obj = apply(obj, 2, as.double)
		storage.mode(obj) <- "double"
		dim(obj) = dd
		dimnames(obj) = dn
		obj
	}
)

asWKTSpatialPoints = function(x, digits = 6) {
	data.frame(geometry = paste("POINT(",unlist(lapply(data.frame(
		t(signif(coordinates(x),digits = digits))),
		paste, collapse=" ")),")",sep=""))
}

"print.SpatialPoints" <- function(x, ..., digits = 6, asWKT = .asWKT)
{
	cat("SpatialPoints:\n")
	if (asWKT) 
		print(asWKTSpatialPoints(x, digits))
	else
		print(x@coords)
	pst <- paste(strwrap(paste(
		"Coordinate Reference System (CRS) arguments:", 
		proj4string(x))), collapse="\n")
	cat(pst, "\n")
}
setMethod("show", "SpatialPoints", function(object) print.SpatialPoints(object))

plot.SpatialPoints = function(x, pch = 3, axes = FALSE, add = FALSE, 
	xlim = NULL, ylim = NULL, ..., setParUsrBB=FALSE, cex = 1, col = 1, lwd = 1, bg = 1) 
{
	if (! add)
		plot(as(x, "Spatial"), axes = axes, xlim = xlim, ylim = ylim, 
			..., setParUsrBB=setParUsrBB)
	cc = coordinates(x)
	points(cc[,1], cc[,2], pch = pch, cex = cex, col = col, lwd = lwd, bg = bg)
}
setMethod("plot", signature(x = "SpatialPoints", y = "missing"),
	function(x,y,...) plot.SpatialPoints(x,...))

points.SpatialPoints = function(x, y = NULL, ...) points(coordinates(x), ...)

setMethod("coordinates", "SpatialPoints", function(obj) obj@coords)

as.data.frame.SpatialPoints = function(x, row.names, optional, ...) data.frame(x@coords)

setAs("SpatialPoints", "data.frame", function(from) as.data.frame(from))

subset.SpatialPoints <- function(x, subset, select, drop = FALSE, ...) {
	if (!missing(select) && (length(select) < 2)) 
		stop("selecting too few coordinate columns")
	res <- SpatialPoints(subset(coordinates(x), subset, select, 
		drop = drop), proj4string = proj4string(x))
	res
}

row.names.SpatialPoints <- function(x) {
    ret = dimnames(slot(x, "coords"))[[1]]
	if (is.null(ret))
		ret = seq_len(nrow(slot(x, "coords")))
	ret
}

"row.names<-.SpatialPoints" <- function(x, value) {
    dimnames(slot(x, "coords"))[[1]] <- value
	x
}

#"[.SpatialPoints" =  function(x, i, j, ..., drop = T) {
setMethod("[", "SpatialPoints", function(x, i, j, ..., drop = TRUE) {
	if (!missing(j))
		warning("j index ignored")
	drop = FALSE
	if (is.character(i))
		i <- match(i, row.names(x))
	else if (is(i, "Spatial"))
		i = !is.na(over(x, geometry(i)))
	if (any(is.na(i)))
		stop("NAs not permitted in row index")
#	SpatialPoints(coords=x@coords[i, , drop=drop], 
#		proj4string = CRS(proj4string(x)))
	x@coords = x@coords[i, , drop = FALSE]
	if (drop)
		x@bbox = .bboxCoords(x@coords)
	x
})

setMethod("coordnames", signature(x = "SpatialPoints"),
	function(x) dimnames(x@coords)[[2]])

setReplaceMethod("coordnames", signature(x = "SpatialPoints", value = "character"),
	function(x, value) {
		dimnames(x@bbox)[[1]] = value
		dimnames(x@coords)[[2]] = value
		x
	}
)

length.SpatialPoints = function(x) { nrow(x@coords) }