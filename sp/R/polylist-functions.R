# Polygon classes


Map2Poly4 <- function(Map, region.id=NULL, projargs=as.character(NA)) {
	if (class(Map) != "Map") stop("not a Map")
	if (attr(Map$Shapes,'shp.type') != 'poly')
		stop("maptype not poly")
	Map2maplim <- function(Map) {
		if (class(Map) != "Map") stop("not a Map")
		res <- cbind(attr(Map$Shapes, 'minbb')[1:2], 
			attr(Map$Shapes, 'maxbb')[1:2])
		rownames(res) <- c("x", "y")
		colnames(res) <- c("min", "max")
		res
	}
	if (is.null(region.id) || 
		length(region.id) != attr(Map$Shapes,'nshps')) {
		region.id <- as.character(1:attr(Map$Shapes,'nshps'))
	} else {
		region.id <- as.character(region.id)
	}
	res <- .get.Polylist4(Map=Map, region.id=region.id, projargs=projargs)
	
	SD <- new("SpatialData", bbox=Map2maplim(Map), 
		proj4string=CRS(projargs))
	PL4 <- new("Polylist4", SD, polygons=res, region.id=region.id, 
		within=as.integer(NA))
	PL4
}

.get.Polylist4 <- function(Map, region.id=NULL, projargs=NA) {
	n <- attr(Map$Shapes,'nshps')
	CRSobj <- CRS(projargs)
	res <- vector(mode="list", length=n)
	nParts <- integer(n)
	for (i in 1:n) nParts[i] <- attr(Map$Shapes[[i]], "nParts")
	for (i in 1:n) {
		bbox <- matrix(c(attr(Map$Shapes[[i]], "bbox")), 2, 2)
		rownames(bbox) <- c("x", "y")
		colnames(bbox) <- c("min", "max")
		SD <- new("SpatialData", bbox=bbox, proj4string=CRSobj)
		if (nParts[i] > 1)
			res[[i]] <- .getMultiShp4(Map$Shapes[[i]], 
			nParts[i], SD, region.id[i])
		else {	
			res[[i]] <- new("Polygon4", SD,
				coords=Map$Shapes[[i]]$verts,
				nVerts=as.integer(attr(Map$Shapes[[i]], 
					"nVerts")),
				nParts=as.integer(1),
				pStart.from=as.integer(1),
				pStart.to=as.integer(attr(Map$Shapes[[i]], 
					"nVerts")),
				RingDir=as.integer(as.vector(attr(
					Map$Shapes[[i]], "RingDir"))),
				ringDir=as.integer(NA),
				region.id=region.id[i])
		}
		rD <- integer(nParts[i])
		for (j in 1:nParts[i]) rD[j] <- .ringDir4(res[[i]], j)
		res[[i]]@ringDir <- as.integer(rD)
	}
	invisible(res)
}

.getMultiShp4 <- function(shp, nParts, SD, reg.id) {
	Pstart <- shp$Pstart
	nVerts <- attr(shp, "nVerts")
	from <- integer(nParts)
	to <- integer(nParts)
	from[1] <- 1
	for (j in 1:nParts) {
		if (j == nParts) to[j] <- nVerts
		else {
			to[j] <- Pstart[j+1]
			from[j+1] <- to[j]+1
		}
	}
	res <- shp$verts[from[1]:to[1],]
	if (nParts > 1) {
	    for (j in 2:nParts) {
	        res <- rbind(res, c(NA, NA))
	        res <- rbind(res, shp$verts[from[j]:to[j],])
	     }
	}
	for (j in 1:nParts) {
		from[j] <- from[j] + (j-1)
		to[j] <- to[j] + (j-1)
	}
	P4 <- new("Polygon4", SD,
		coords=res,
		nVerts=as.integer(nVerts),
		nParts=as.integer(nParts),
		pStart.from=as.integer(from),
		pStart.to=as.integer(to),
		RingDir=as.integer(as.vector(attr(shp, "RingDir"))),
		ringDir=as.integer(NA),
		region.id=reg.id)
	invisible(P4)
}


# based on SHPRingDir_2d, modified to use current ring only, and to strip
# out last vertex if identical with first

.ringDir4 <- function(xy, ring) {
	nParts <- xy@nParts
	if (ring > nParts) stop("ring too large")
	from <- xy@pStart.from
	to <- xy@pStart.to
	a <- xy@coords[from[ring]:to[ring],1]
	b <- xy@coords[from[ring]:to[ring],2]
	nvx <- length(b)

	if((a[1] == a[nvx]) && (b[1] == b[nvx])) {
		a <- a[-nvx]
		b <- b[-nvx]
		nvx <- nvx - 1
	}

	tX <- 0.0
	dfYMax <- max(b)
	ti <- 1
	for (i in 1:nvx) {
		if (b[i] == dfYMax && a[i] > tX) ti <- i
	}
	if ( (ti > 1) & (ti < nvx) ) { 
		dx0 = a[ti-1] - a[ti]
      		dx1 = a[ti+1] - a[ti]
      		dy0 = b[ti-1] - b[ti]
      		dy1 = b[ti+1] - b[ti]
   	} else {
#   /* if the tested vertex is at the origin then continue from 0 (1) */ 
     		dx1 = a[2] - a[1]
      		dx0 = a[nvx] - a[1]
      		dy1 = b[2] - b[1]
      		dy0 = b[nvx] - b[1]
   	}
	v3 = ( (dx0 * dy1) - (dx1 * dy0) )
	if ( v3 > 0 ) return (1)
   	else return (-1)
}

plot.Polylist4 <- function(x, col, border=par("fg"), add=FALSE, 
	xlim=NULL, ylim=NULL, xlab="", ylab="", asp=1, xpd = NULL, 
	density = NULL, angle = 45, ...) {
	if (!is(x, "Polylist4")) stop("Not a Polygon4 object")
	if (!add) {
		maplim <- x@bbox
		if (is.null(maplim))
			if (is.null(xlim) || is.null(ylim))
				stop("map limits missing")
		if (is.null(xlim)) xlim <- c(maplim["x",])
		if (is.null(ylim)) ylim <- c(maplim["y",])
		plot(x=xlim, y=ylim, xlim=xlim, ylim=ylim, type="n",
		asp=asp, xlab=xlab, ylab=ylab, ...)
	}
	if (missing(col)) return()
	n <- length(x@polygons)
        if (length(border) != n) {
            	border <- rep(border, n, n)
        }
    	if (!is.null(density)) {
        	if (length(density) != n) {
            	density <- rep(density, n, n)
        	}
        	if (length(angle) != n) {
            	angle <- rep(angle, n, n)
        	}
        	for (j in 1:n) polygon(x@polygons[[j]]@coords, 
			border = border[j], xpd = xpd, density = density[j], 
			angle = angle[j])
    	} else {
		if (length(col) != n) {
			col <- rep(col, n, n)
		}
		for (j in 1:n) 
			polygon(x@polygons[[j]]@coords, col=col[j], 
				border=border[j], xpd = xpd)
	}
}

