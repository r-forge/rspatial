#
plot.SpatialRings <- function(x, col, border = par("fg"), add=FALSE, xlim=NULL, 
	ylim=NULL, asp=1, xpd = NULL, density = NULL, angle = 45, pbg=NULL, ...) {

	if (is.null(pbg))
#ifdef R
		pbg = par("bg") # transparent!
#else
#		pbg = 0
#endif
	if (!is(x, "SpatialRings")) 
		stop("Not a SpatialRings object")

	if (!add) plot.Spatial(x, xlim=xlim, ylim=ylim, asp=asp, ...)

	if (missing(col)) col <- NA
	n <- length(x@polygons)
	if (length(border) != n)
		border <- rep(border, n, n)
	pO <- x@plotOrder
	if (!is.null(density)) {
		if (length(density) != n)
			density <- rep(density, n, n)
		if (length(angle) != n)
			angle <- rep(angle, n, n)
		for (j in pO) 
				.polygonRingHoles(x@polygons[[j]], border = border[j], 
				xpd = xpd, density = density[j], angle = angle[j], pbg = pbg) 
	} else {
		if (length(col) != n)
			col <- rep(col, n, n)
		for (j in pO) 
			.polygonRingHoles(x@polygons[[j]], col=col[j], 
				border=border[j], xpd = xpd, pbg = pbg)
	}
}

.polygonRingHoles <- function(R4, col=NA, border=NULL, xpd=NULL, density=NULL,
	angle=45, pbg) {
	if (!is(R4, "Ring4")) 
		stop("Not a Ring4 object")
	coords <- R4@coords
	nParts <- nParts.matrix(coords)
	xyList <- .NAmat2xyList(coords)
	if (is.na(col)) hatch <- TRUE
	else hatch <- FALSE
	pO <- R4@plotOrder
	
	for (i in pO) {
		if (hatch) {
			if (R4@ringDir[i] == 1)
				.polygon(xyList[[i]], 
					border = border, xpd = xpd, 
					density = density, angle = angle,
					hatch=TRUE)
			else .polygon(xyList[[i]], 
					border = border, xpd = xpd, col=pbg, 
					density = NULL)
		} else {
			if (R4@ringDir[i] == 1)
				.polygon(xyList[[i]], 
					border = border, xpd = xpd, col=col)
			else .polygon(xyList[[i]], 
				border = border, xpd = xpd, col=pbg)
		}
	}
}


# .polygon tries to catch the numerous R/S-Plus differences...
.polygon = function(x, y = NULL, density = NULL, angle = 45,
	border = NULL, col = NA, lty = NULL, xpd = NULL, hatch=NA, ...) {
#ifdef R
	if (is.na(hatch)) polygon(x = x, y = y, border = border, 
		col = col, lty = lty, xpd = xpd, ...)
	# col=NA overrides hatching
	else polygon(x = x, y = y, density = density, angle = angle, 
		border = border, lty = lty, xpd = xpd, ...)
#else
	# polygon(x, y, density=-1, angle=45, border=T, col=par("col"))
#	if (is.matrix(x))
#		dimnames(x) = list(NULL, c("x", "y")) # may not be necessary
#	if (is.null(density))
#		density = -1
#	if (!(is.logical(border) && !is.na(border)))
#		border = is.null(border)
#	else if (is.na(border))
#		border = F
#	if (is.na(col))
#		col = par("col")
#	polygon(x = x, density = density, angle = angle,
#		border = border, col = col, ...)
#endif
}


