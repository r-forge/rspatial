# to be moved to glue with maptools:

as.SpatialRings.Shapes <- function(shapes, IDs, 
	proj4string=CRS(as.character(NA))) {
	if (attr(shapes, "shp.type") != "poly")
		stop("Not polygon shapes")
	if (missing(IDs)) stop("IDs required")
	if (length(IDs) != attr(shapes,'nshps')) 
		stop("Number of shapes and IDs differ")
	tab <- table(factor(IDs))
	n <- length(tab)
	IDss <- names(tab)
	reg <- match(IDs, IDss)
	belongs <- lapply(1:n, function(x) which(x == reg))
# assemble the list of Srings
	Srl <- vector(mode="list", length=n)
	for (i in 1:n) {
		nParts <- length(belongs[[i]])
		srl <- NULL
		for (j in 1:nParts) {
			jres <- .shp2srs(shapes[[belongs[[i]][j]]], 
				nParts.shp(shapes[[belongs[[i]][j]]]), 
				proj4string=proj4string)
			srl <- c(srl, jres)
		}
		Srl[[i]] <- Srings(srl, ID=IDss[i])
	}
	res <- as.SpatialRings.SringsList(Srl)
	res
}

# to be moved to glue with maps:

as.SpatialRings.map <- function(map, IDs, proj4string=CRS(as.character(NA))) {
	if (missing(IDs)) stop("IDs required")
	xyList <- .NAmat2xyList(cbind(map$x, map$y))
	if (length(xyList) != length(IDs)) stop("map and IDs differ in length")
	tab <- table(factor(IDs))
	n <- length(tab)
	IDss <- names(tab)
	reg <- match(IDs, IDss)
	belongs <- lapply(1:n, function(x) which(x == reg))
# assemble the list of Srings
	Srl <- vector(mode="list", length=n)
	for (i in 1:n) {
		nParts <- length(belongs[[i]])
		srl <- vector(mode="list", length=nParts)
		for (j in 1:nParts) {
			srl[[j]] <- Sring(coords=xyList[[belongs[[i]][j]]], 
				proj4string=proj4string)
		}
		Srl[[i]] <- Srings(srl, ID=IDss[i])
	}
	res <- as.SpatialRings.SringsList(Srl)
	res
}

# to be moved to glue with RarcInfo:

as.SpatialRings.pal <- function(arc, pal, IDs, dropPoly1=TRUE, 
	proj4string=CRS(as.character(NA))) {
	if (missing(IDs)) stop("IDs required")
	if (dropPoly1) pale <- lapply(pal[[2]][-1], function(x) x[[1]])
	else pale <- lapply(pal[[2]], function(x) x[[1]])
	if (length(pale) != length(IDs)) stop("map and IDs differ in length")
	tab <- table(factor(IDs))
	n <- length(tab)
	IDss <- names(tab)
	reg <- match(IDs, IDss)
	belongs <- lapply(1:n, function(x) which(x == reg))
# assemble the list of Srings
	Srl <- vector(mode="list", length=n)
	for (i in 1:n) {
		nParts <- length(belongs[[i]])
		srl <- vector(mode="list", length=nParts)
		for (j in 1:nParts) {
			this <- belongs[[i]][j]
			paleij <- pale[[this]]
			nArcs <- length(paleij)
			x <- NULL
			y <- NULL
			for (k in 1:nArcs) {
				kk <- paleij[k]
				if (kk > 0) {
					x <- c(x, arc[[2]][[kk]][[1]])
					y <- c(y, arc[[2]][[kk]][[2]])
				} else {
					x <- c(x, rev(arc[[2]][[-kk]][[1]]))
					y <- c(y, rev(arc[[2]][[-kk]][[2]]))
				}
			}
			srl[[j]] <- Sring(coords=cbind(x, y), 
				proj4string=proj4string)	
		}
		Srl[[i]] <- Srings(srl, ID=IDss[i])
	}
	res <- as.SpatialRings.SringsList(Srl)
	res
}

#as.SpatialRings.matrixList <- function(xyList, region.id=NULL, 
#				projargs=as.character(NA), verbose=TRUE) {
# assemble the list of Ring4s
#	n <- length(xyList)
#	if (is.null(region.id) || length(region.id) != n) {
#		region.id <- as.character(1:n)
#	} else {
#		region.id <- as.character(region.id)
#	}
#	R4s <- vector(mode="list", length=n)
#	for (i in 1:n) {
#		R4s[[i]] <- as.Ring4.matrix(xyList[[i]], 
#				region.id=region.id[i], projargs=projargs, 
#				verbose=verbose)
#	}
# check their plot order
#	pO <- 1:n
#	after <- as.integer(rep(NA, n))
#	rD <- sapply(R4s, function(x) x@ringDir[x@plotOrder[1]])
#	.saneRD(rD)
#	r1 <- .insidersR4(R4s, rD)
#	if (!all(sapply(r1, is.null))) {
#		lres <- .lbuild(.afters(r1), rD)
#		pO <- lres$pO
#		after <- lres$after
#	}
# check their ring directions and change if improbable
#	rD <- sapply(R4s, function(x) x@ringDir[which(x@plotOrder == 1)])
#	.saneRD(rD)
#	if (any((rD == -1) & is.na(after))) {
#		oddCC <- which((rD == -1) & is.na(after))
#		for (i in oddCC) {
#			tgt <- which(R4s[[i]]@plotOrder == 1)
#			xyList <- .NAmat2xyList(R4s[[i]]@coords)
#			xyList[[tgt]] <- xyList[[tgt]][nrow(xyList[[tgt]]):1,]
#			reved <- .xyList2NAmat(xyList)
#			R4s[[i]] <- as.Ring4.matrix(reved, 
#					region.id=region.id[i], 
#					projargs=projargs, verbose=verbose)
#			if (verbose)
#				warning(paste("ring direction changed in polygon", i))
#		}
#	}
#
#	res <- SpatialRings(R4s, pO, region.id, projargs=projargs)
#	res
#}


#as.Ring4.matrix <- function(xy, region.id=NULL, projargs=as.character(NA), 
#	verbose=TRUE) {
#	xyList <- .NAmat2xyList(xy)
#	nParts <- length(xyList)
# check their plot order
#	pO <- 1:nParts
#	after <- as.integer(rep(NA, nParts))
#	rD <- sapply(xyList, .ringDirxy)
#	.saneRD(rD)
#	if (nParts > 1) {
#		r1 <- .insiders(xyList, rD)
#		if (!all(sapply(r1, is.null))) {
#			lres <- .lbuild(.afters(r1), rD)
#			pO <- lres$pO
#			after <- lres$after
#		}
#	} else {
#		pO <- 1
#		after <- as.integer(NA)
#	}
# check their ring directions and change if improbable
#	xyList <- .checkRD1(pO, after, rD, xyList, verbose=verbose)
#	rD <- sapply(xyList, .ringDirxy)
#	.saneRD(rD)
#	xy <- .xyList2NAmat(xyList)
#	
#	Sp <- new("Spatial", bbox=.bboxSlot(xy), proj4string=CRS(projargs))
#	res <- new("Ring4", Sp, coords=xy, ringDir=as.integer(rD), 
#		region.id=region.id, plotOrder=as.integer(pO))
#	res
#}

SpatialRings <- function(Srl, pO=1:length(Srl)) {
	bb <- .bboxSrs(Srl)
	projargs <- proj4string(Srl[[1]])
	Sp <- new("Spatial", bbox=bb, proj4string=CRS(projargs))
	res <- new("SpatialRings", Sp, polygons=Srl, plotOrder=as.integer(pO))
	res
}

Sring <- function(coords, proj4string=CRS(as.character(NA)), hole=as.logical(NA)) {
	sl <- Sline(coords, proj4string=proj4string)
	rD <- .ringDirxy(coordinates(sl))
	cents <- .RingCentrd_2d(coordinates(sl))
	.saneRD(rD)
	if (is.na(hole)) {
		hole <- FALSE
		if (rD < 0) hole <- TRUE
	}
	res <- new("Sring", sl, labpt=as.numeric(c(cents$xc, cents$yc)), 
		area=as.numeric(cents$area), hole=as.logical(hole), 
		ringDir=as.integer(rD))
	res
}

Srings <- function(srl, ID) {
	if (any(sapply(srl, function(x) !is(x, "Sring"))))
		stop("srl not a list of Sring objects")
	projargs <- unique(sapply(srl, proj4string))
	if (length(projargs) > 1) 
		stop("differing projections among Sring objects")
	if (missing(ID)) stop("Single ID required")
	if (length(ID) != 1) stop("Single ID required")

	nParts <- length(srl)
# check their plot order
	after <- as.integer(rep(NA, nParts))
	area <- sapply(srl, function(x) x@area)
	pO <- order(area, decreasing=TRUE)
#	rD <- sapply(srl, function(x) x@ringDir)
#	.saneRD(rD)
#	if (nParts > 1) {
#		r1 <- .insiders(srl, rD)
#		if (!all(sapply(r1, is.null))) {
#			lres <- .lbuild(.afters(r1), rD)
#			pO <- lres$pO
#			after <- lres$after
#		}
#	} else {
#		pO <- 1
#		after <- as.integer(NA)
#	}
# check their ring directions and change if improbable
	rD <- sapply(srl, function(x) x@ringDir)
	holes <- sapply(srl, function(x) x@hole)
	areas <- sapply(srl, getSringAreaSlot)
	marea <- which.max(areas)
	which_list <- ifelse(length(srl) == 1, 1, marea)
	if (holes[which_list]) {
		crds <- srl[[which_list]]@coords
		srl[[which_list]] <- Sring(coords=crds[nrow(crds):1,],
			proj4string=CRS(projargs))
	}
	holes <- sapply(srl, function(x) x@hole)
	Sarea <- abs(sum(area * holes) - sum(area * !holes))
#	srl <- .checkRD2(pO, after, rD, srl)
# assign label point to the largest member ring
	lpt <- t(sapply(srl, getSringLabptSlot))
	labpt <- lpt[which_list,]
		
	Sp <- new("Spatial", bbox=.bboxSrs(srl), proj4string=CRS(projargs))
	res <- new("Srings", Sp, Srings=srl, plotOrder=as.integer(pO),
		labpt=as.numeric(labpt), ID=as.character(ID), area=Sarea)
	res

}


as.SpatialRings.SringsList <- function(Srl) {
	if (any(sapply(Srl, function(x) !is(x, "Srings"))))
		stop("srl not a list of Srings objects")
	projargs <- unique(sapply(Srl, proj4string))
	if (length(projargs) > 1) 
		stop("differing projections among Srings objects")

	n <- length(Srl)

# check their plot order
#	pO <- 1:n
#	after <- as.integer(rep(NA, n))
	area <- sapply(Srl, function(x) x@area)
	pO <- as.integer(order(area, decreasing=TRUE))

#	rD <- sapply(Srl, function(x) {
#		pO1 <- which(x@plotOrder == 1);
#		x@Srings[[pO1]]@ringDir
#		})
#	.saneRD(rD)
#	r1 <- .insidersR4a(Srl, rD)
#	if (!all(sapply(r1, is.null))) {
#		lres <- .lbuild(.afters(r1), rD)
#		pO <- lres$pO
#		after <- lres$after
#	}
# check their ring directions and change if improbable
#	if (any((rD == -1) & is.na(after))) {
#		oddCC <- which((rD == -1) & is.na(after))
#		for (i in oddCC) {
#			Srs <- Srl[[i]]
#			tgt <- which(Srs@plotOrder == 1)
#			crds <- getSringCoordsSlot(Srs@Srings[[tgt]])
#			projargs <- proj4string(Srs)
#			Srs[[tgt]] <- Sring(coords=crds[nrow(crds):1,], 
#				proj4string=CRS(projargs))
#			Srl[[i]] <- Srs
#			warning(paste("ring direction changed in polygon", i))
#		}
#	}

	res <- SpatialRings(Srl, pO)
	res
}

plotSpatialRings <- function(SR) {
	xr <- SR@bbox[1,]
	yr <- SR@bbox[2,]
	frame()
	plot.window(xlim=xr, ylim=yr, asp=1)
	pls <- getSRpolygonsSlot(SR)
	pO <- getSRplotOrderSlot(SR)
	for (i in pO) {
		Srs <- getSringsSringsSlot(pls[[i]])
		pOi <- getSringsplotOrderSlot(pls[[i]])
		for (j in pOi) polygon(getSringCoordsSlot(Srs[[j]]))
	}
}

#"[.SpatialRings" =  function(x, i, j, ..., drop = T) {
setMethod("[", "SpatialRings", function(x, i, j, ..., drop = T) {
	if (!missing(j)) stop("only a single index is allowed for [.SpatialRings")
	# SpatialRings(x[i], pO = order(x@plotOrder))
	SpatialRings(x@polygons[i], pO = order(x@plotOrder[i]))
})
