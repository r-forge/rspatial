# Lancaster, Thu Nov  4 14:44:00 GMT 2004, fresh start from icelfloe

if (!isGeneric("bbox"))
	setGeneric("bbox", function(obj)
		standardGeneric("bbox"))
if (!isGeneric("coordinates"))
	setGeneric("coordinates", function(obj)
		standardGeneric("coordinates"))

#if (!isGeneric("coordinates<-"))
#	setGeneric("coordinates<-", function(obj, value)
#		standardGeneric("coordinates<-"))
if (!isGeneric("arcs")) 
	setGeneric("arcs", function(obj)
		standardGeneric("arcs"))
if (!isGeneric("rings"))
	setGeneric("rings", function(obj)
		standardGeneric("rings"))
if (!isGeneric("gridded"))
	setGeneric("gridded", function(obj)
		standardGeneric("gridded"))
if (!isGeneric("dimensions"))
	setGeneric("dimensions", function(obj)
		standardGeneric("dimensions"))

setClass("Spatial",
	representation(bbox = "matrix",
		proj4string = "CRS"),
	prototype = list(
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA))), # will not prove valid; ignore
	validity = function(object) {
		if (!is.matrix(object@bbox))
			return("bbox should be a matrix")
		n = dimensions(object)
		# may be relaxed later on:
		if (n > 3 || n < 2)
			return("spatial.dimension should be either 2 or 3") 
		if (any(is.na(object@bbox)))
			return("bbox x and y values should never be NA")
		if (any(object@bbox[,"max"] < object@bbox[,"min"]))
			return("bbox is invalid: max < min")
		if (!is(object@proj4string, "CRS"))
			return("proj4string should be CRS")
		# validate proj4string here
		return(TRUE)
	}
)

setMethod("bbox", "Spatial", function(obj) obj@bbox)
setMethod("dimensions", "Spatial", function(obj) nrow(bbox(obj)))

summary.Spatial = function(object, ...) {
    obj = list()
    obj[["bbox"]] = bbox(object)
    obj[["is.projected"]] = is.projected(object)
    obj[["proj4string"]] = object@proj4string@projargs
    if (is(object, "SpatialPoints"))
        obj[["npoints"]] = nrow(object@coords)
    if (is(object, "SpatialPointsDataFrame"))
        obj[["data"]] = summary(object@data)
	if (is(object, "SpatialGridded"))
		obj[["grid"]] = summary(as(object, "SpatialGridded"))
    class(obj) = "summary.Spatial"
    obj
}

# summary.SpatialRingsDataFrame = summary.Spatial

# setMethod("summary", "SpatialPointsDataFrame", summary.Spatial)

print.summary.Spatial = function(x, ...) {
    cat("Coordinates:\n")
    print(x[["bbox"]])
    cat(paste("Is projected:", x[["is.projected"]], "\n"))
    cat(paste("proj4string : [", x[["proj4string"]], "]\n", sep=""))
    if (!is.null(x$npoints)) {
        cat("Number of points: ")
		cat(x$npoints)
		cat("\n")
	}
    if (!is.null(x$n.polygons)) {
        cat("Number of polygons: ")
		cat(x$n.polygons)
        cat("\n")
    }
	if (!is.null(x$grid)) {
        cat("Grid attributes:\n")
        print(x$grid)
    }
    if (!is.null(x$data)) {
        cat("Data attributes:\n")
        print(x$data)
    }
    invisible(x)
}

