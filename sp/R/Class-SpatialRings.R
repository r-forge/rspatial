setClass("Ring4",
	representation("Spatial",
		coords = "matrix",
		ringDir = "integer",
		region.id = "character",
		plotOrder = "integer"),
	prototype = list(
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		coords = matrix(0),
		ringDir = integer(0),
		region.id = character(0),
		plotOrder = integer(0)),
	validity = function(object) {
			if (ncol(object@coords) != 2)
				return("polygon should have 2 columns")
			return(TRUE)
		}
)

setClass("Spatialrings",
	representation("Spatial",
		polygons = "list",
		region.id = "character",
		plotOrder = "integer"),
	prototype = list(
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		polygons = list(), 
		region.id = character(0), 
		plotOrder = integer(0)),
	validity = function(object) {
		if (length(object@polygons) != length(object@region.id))
			return("length mismatch")
		if (length(object@polygons) != length(object@plotOrder))
			return("length mismatch")
		if (any(unlist(lapply(object@polygons, function(x) 
				!is(x, "Ring4"))))) 
			return("polygons not Ring4 objects")
		return(TRUE)
	}
)

setClass("Sring",
	representation("Sline", ringDir = "integer", labpt = "numeric", 
	area = "numeric"),
	prototype = list(bbox = matrix(rep(NA, 6), 3, 2, 
			dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		coords = matrix(0),
		ringDir = as.integer(NA),
		labpt = as.numeric(NA),
		area = as.numeric(NA)),
	validity = function(object) {
		coords <- coordinates(object)
		start <- coords[1,]
		final <- coords[nrow(coords),]
		if (!identical(start, final)) stop("ring not closed")
		return(TRUE)
})

setClass("Srings",
	representation("Spatial", Srings = "list", plotOrder = "integer", 
	labpt = "numeric", ID = "character"),
	prototype = list(bbox = matrix(rep(NA, 6), 3, 2, 
			dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		Srings = list(), plotOrder = as.integer(NA),
		labpt = as.numeric(NA),
		ID = as.character(NA)),
	validity = function(object) {
		if (any(sapply(object@Srings, function(x) !is(x, "Sring"))))				stop("not a list of Sring objects")
		if (length(object@Srings) != length(object@plotOrder))
			stop("plotOrder and Srings differ in length")
		return(TRUE)
})

setClass("SpatialRings",
representation("Spatial",
		polygons = "list",
		plotOrder = "integer"),
	prototype = list(
		bbox = matrix(rep(NA, 6), 3, 2, dimnames = list(NULL, c("min","max"))),
		proj4string = CRS(as.character(NA)),
		polygons = list(), 
		plotOrder = integer(0)),
	validity = function(object) {
		if (length(object@polygons) != length(object@plotOrder))
			return("length mismatch")
		if (any(unlist(lapply(object@polygons, function(x) 
				!is(x, "Srings"))))) 
			return("polygons not Srings objects")
		return(TRUE)
	}
)

getSringCoordsSlot <- function(Sring) Sring@coords

getSringLabptSlot <- function(Sring) Sring@labpt

getSringAreaSlot <- function(Sring) Sring@area

getSringsSringsSlot <- function(Srings) Srings@Srings

getSringsplotOrderSlot <- function(Srings) Srings@plotOrder

getSringsLabptSlot <- function(Srings) Srings@labpt

getSringsIDSlot <- function(Srings) Srings@ID

getSRpolygonsSlot <- function(SR) SR@polygons

getSRplotOrderSlot <- function(SR) SR@plotOrder

getSRSringsLabptSlots <- function(SR) {
	Srs <- getSRpolygonsSlot(SR)
	t(sapply(Srs, getSringsLabptSlot))
}

getSRSringsIDSlots <- function(SR) {
	Srs <- getSRpolygonsSlot(SR)
	sapply(Srs, getSringsIDSlot)
}

getSRnParts <- function(SR) {
	Srs <- getSRpolygonsSlot(SR)
	sapply(Srs, function(x) length(getSringsSringsSlot(x)))
}


