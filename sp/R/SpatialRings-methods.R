as.SpatialRings.Shapelist <- function(shp, region.id=NULL, 
				projargs=as.character(NA), verbose=TRUE) {
# assemble the list of matrices
	n <- attr(shp,'nshps')
	xyList <- vector(mode="list", length=n)
	for (i in 1:n) {
		if (nParts.shp(shp[[i]]) > 1) 
			xyList[[i]] <- .shp2xy(shp[[i]], nParts.shp(shp[[i]]))
		else 
			xyList[[i]] <- shp[[i]]$verts
	}
	res <- as.SpatialRings.matrixList(xyList, region.id=region.id,
		projargs=projargs, verbose=verbose)
	res
}


as.SpatialRings.matrixList <- function(xyList, region.id=NULL, 
				projargs=as.character(NA), verbose=TRUE) {
# assemble the list of Ring4s
	n <- length(xyList)
	if (is.null(region.id) || length(region.id) != n) {
		region.id <- as.character(1:n)
	} else {
		region.id <- as.character(region.id)
	}
	R4s <- vector(mode="list", length=n)
	for (i in 1:n) {
		R4s[[i]] <- as.Ring4.matrix(xyList[[i]], 
				region.id=region.id[i], projargs=projargs, 
				verbose=verbose)
	}
# check their plot order
	pO <- 1:n
	after <- as.integer(rep(NA, n))
	rD <- sapply(R4s, function(x) x@ringDir[x@plotOrder[1]])
	.saneRD(rD)
	r1 <- .insidersR4(R4s, rD)
	if (!all(sapply(r1, is.null))) {
		lres <- .lbuild(.afters(r1), rD)
		pO <- lres$pO
		after <- lres$after
	}
# check their ring directions and change if improbable
	rD <- sapply(R4s, function(x) x@ringDir[which(x@plotOrder == 1)])
	.saneRD(rD)
	if (any((rD == -1) & is.na(after))) {
		oddCC <- which((rD == -1) & is.na(after))
		for (i in oddCC) {
			tgt <- which(R4s[[i]]@plotOrder == 1)
			xyList <- .NAmat2xyList(R4s[[i]]@coords)
			xyList[[tgt]] <- xyList[[tgt]][nrow(xyList[[tgt]]):1,]
			reved <- .xyList2NAmat(xyList)
			R4s[[i]] <- as.Ring4.matrix(reved, 
					region.id=region.id[i], 
					projargs=projargs, verbose=verbose)
			if (verbose)
				warning(paste("ring direction changed in polygon", i))
		}
	}

	res <- SpatialRings(R4s, pO, region.id, projargs=projargs)
	res
}


as.Ring4.matrix <- function(xy, region.id=NULL, projargs=as.character(NA), 
	verbose=TRUE) {
	xyList <- .NAmat2xyList(xy)
	nParts <- length(xyList)
# check their plot order
	pO <- 1:nParts
	after <- as.integer(rep(NA, nParts))
	rD <- sapply(xyList, .ringDirxyList)
	.saneRD(rD)
	if (nParts > 1) {
		r1 <- .insiders(xyList, rD)
		if (!all(sapply(r1, is.null))) {
			lres <- .lbuild(.afters(r1), rD)
			pO <- lres$pO
			after <- lres$after
		}
	} else {
		pO <- 1
		after <- as.integer(NA)
	}
# check their ring directions and change if improbable
	xyList <- .checkRD1(pO, after, rD, xyList, verbose=verbose)
	rD <- sapply(xyList, .ringDirxyList)
	.saneRD(rD)
	xy <- .xyList2NAmat(xyList)
	
	Sp <- new("Spatial", bbox=.bboxSlot(xy), proj4string=CRS(projargs))
	res <- new("Ring4", Sp, coords=xy, ringDir=as.integer(rD), 
		region.id=region.id, plotOrder=as.integer(pO))
	res
}


SpatialRings <- function(R4s, pO, region.id=NULL, projargs=as.character(NA)) {
	bb <- .bboxR4s(R4s)
	Sp <- new("Spatial", bbox=bb, proj4string=CRS(projargs))
	res <- new("SpatialRings", Sp, polygons=R4s, region.id=region.id, 
		plotOrder=as.integer(pO))
	res
}

