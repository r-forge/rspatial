#.shp2xy <- function(shp, nParts) {
#	Pstart <- shp$Pstart
#	nVerts <- nrow(shp$verts)
#	from <- integer(nParts)
#	to <- integer(nParts)
#	from[1] <- 1
#	for (j in 1:nParts) {
#		if (j == nParts) to[j] <- nVerts
#		else {
#			to[j] <- Pstart[j+1]
#			from[j+1] <- to[j]+1
#		}
#	}
#	res <- shp$verts[from[1]:to[1],]
#	if (nParts > 1) {
#	    for (j in 2:nParts) {
#		res <- rbind(res, c(NA, NA))
#		res <- rbind(res, shp$verts[from[j]:to[j],])
#	     }
#	}
#	res
#}
.shp2srs <- function(shp, nParts, proj4string=CRS(as.character(NA))) {
	Pstart <- shp$Pstart
	nVerts <- nrow(shp$verts)
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
	srl <- vector(mode="list", length=nParts)
	for (j in 1:nParts) {
		srl[[j]] <- Sring(coords=shp$verts[from[j]:to[j],], 
			proj4string=proj4string)
	}
	srl
}

nParts.shp <- function(shp) attr(shp, "nParts")

#nParts.matrix <- function(xy) {
#	NAs <- unclass(attr(na.omit(xy), "na.action"))
#	if ((length(NAs) == 1) && (NAs == nrow(xy))) NAs <- NULL
#	nParts <- length(NAs) + 1
#}

.NAmat2xyList <- function(xy) {
	NAs <- unclass(attr(na.omit(xy), "na.action"))
	if ((length(NAs) == 1) && (NAs == nrow(xy))) {
		xy <- xy[-nrow(xy)]
		NAs <- NULL
	}
	nParts <- length(NAs) + 1
	res <- vector(mode="list", length=nParts)
	from <- integer(nParts)
	to <- integer(nParts)
	from[1] <- 1
	to[nParts] <- nrow(xy)
	if (nParts > 1) {
		for (i in 2:nParts) {
			to[(i-1)] <- NAs[(i-1)]-1
			from[i] <- NAs[(i-1)]+1
		}
	}
	for (i in 1:nParts) res[[i]] <- xy[from[i]:to[i],]
	res
}

#.xyList2NAmat <- function(xyList) {
#	nParts <- length(xyList)
#	res <- xyList[[1]]
#	if (nParts > 1) {
#		for(i in 2:nParts) 
#			res <- rbind(res, c(NA,NA), xyList[[i]])
#	}
#	res
#}

.ringDirxy <- function(xy) {
	a <- xy[,1]
	b <- xy[,2]
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
   	} else if (ti == nvx) {
		dx0 = a[ti-1] - a[ti]
      		dx1 = a[1] - a[ti]
      		dy0 = b[ti-1] - b[ti]
      		dy1 = b[1] - b[ti]
   	} else {
#   /* if the tested vertex is at the origin then continue from 0 (1) */ 
     		dx1 = a[2] - a[1]
      		dx0 = a[nvx] - a[1]
      		dy1 = b[2] - b[1]
      		dy0 = b[nvx] - b[1]
   	}
	v3 = ( (dx0 * dy1) - (dx1 * dy0) )
	if ( v3 > 0 ) return(as.integer(1))
   	else return(as.integer(-1))
}

.bboxSlot <- function(x) {
	r1 <- range(x[,1], na.rm=TRUE)
	r2 <- range(x[,2], na.rm=TRUE)
	res <- rbind(r1, r2)
	colnames(res) <- c("min", "max")
	res
}

.bboxR4s <- function(R4s) {
	x <- sapply(R4s, function(x) bbox.R4(x)[1,])
	y <- sapply(R4s, function(x) bbox.R4(x)[2,])
	r1 <- range(x, na.rm=TRUE)
	r2 <- range(y, na.rm=TRUE)
	res <- rbind(r1, r2)
	colnames(res) <- c("min", "max")
	res

}

.bboxSrs <- function(R4s) {
	x <- sapply(R4s, function(x) bbox.R4(x)[1,])
	y <- sapply(R4s, function(x) bbox.R4(x)[2,])
	r1 <- range(x, na.rm=TRUE)
	r2 <- range(y, na.rm=TRUE)
	res <- rbind(r1, r2)
	colnames(res) <- c("min", "max")
	res

}

bbox.R4 <- function(x) {
	x@bbox
}

.bbox1 <- function(x) {
	r1 <- range(x[,1], na.rm=TRUE)
	r2 <- range(x[,2], na.rm=TRUE)
	res <- c(r1[1], r2[1], r1[2], r2[2])
	res
}

.bbox2 <- function(x) {
	r1 <- range(x@coords[,1], na.rm=TRUE)
	r2 <- range(x@coords[,2], na.rm=TRUE)
	res <- c(r1[1], r2[1], r1[2], r2[2])
	res
}

#.insiders <- function(pl, rD) {
#	if (is(pl[[1]], "Sring")) pl <- lapply(pl, getSringCoordsSlot)
#
# attempts to find which polygons among a set of polygons are inside which 
# others, and should be painted by polygon() after the polygons within 
# which they lie
#
#	n <- length(pl)
#	bbs <- matrix(0, nrow=n, ncol=4)
#	for (i in 1:n) bbs[i,] <- .bbox1(pl[[i]])
#
# first stage: find polygons with all four corners in their bounding boxes
# inside or equal to those of the other polygons
#
#	res <- .Call("insiders", as.integer(n), as.double(bbs), PACKAGE="sp")
#	res1 <- vector(mode="list", length=n)
#
#
# second stage: if bboxes meet this condition, do point in polygon to see
# which are fully enclosed, which are equal, and which are not themselves 
# inside, even though the bbox is.
#
#	for (i in 1:n) {
#		if (!is.null(res[[i]])) {
#			ri <- res[[i]]
#			ixc <- pl[[i]][1,1]
#			iyc <- pl[[i]][1,2]
#			int <- logical(length(ri))
#			for (j in 1:length(ri)) {
#				xj <- pl[[ri[j]]]
#				jxc <- na.omit(xj[,1])
#				jyc <- na.omit(xj[,2])
#				pip <- point.in.polygon(ixc, iyc, jxc, 
#					jyc)
#				int[j] <- ((pip == 1) | (pip > 1))
#
# when pip == 1, the first point is fully include in the polygon, for
# pip > 1, the point lies on the polygon boundary, so the relative ring 
# directions need to be checked too. This can still go wrong when the
# ring directions are wrong (maybe not just then).
#
#			}
#			rj <- ri[int]
#			if (length(rj) > 0) {
#				res1[[i]] <- as.integer(rj)
#			}
#		}
#	}
#	res1
#}

#.insidersR4a <- function(pl, rD) {
#
# attempts to find which polygons among a set of polygons are inside which 
# others, and should be painted by polygon() after the polygons within 
# which they lie
#
#
#	n <- length(pl)
#	bbs <- matrix(0, nrow=n, ncol=4)
#	for (i in 1:n) bbs[i,] <- c(pl[[i]]@bbox)
#
# first stage: find polygons with all four corners in their bounding boxes
# inside or equal to those of the other polygons
#
#	res <- .Call("insiders", as.integer(n), as.double(bbs), PACKAGE="sp")
#	res1 <- vector(mode="list", length=n)
#
#
# second stage: if bboxes meet this condition, do point in polygon on the 
# first point only to see which are fully enclosed, which are equal, and 
# which are not themselves inside, even though the bbox is.
#
#	for (i in 1:n) {
#	    if (!is.null(res[[i]])) {
#		ri <- res[[i]]
#		int <- logical(length(ri))
#		srli <- pl[[i]]@Srings
#		lsrli <- length(srli)
#		for (ii in 1:lsrli) {
#		    ixc <- srli[[ii]]@coords[1,1]
#		    iyc <- srli[[ii]]@coords[1,2]
#		    for (j in 1:length(ri)) {
#		    	srlj <- pl[[ri[j]]]@Srings
#			pip <- integer(length(srlj))
#			for (jj in 1:length(srlj)) {
#			    crds <- getSringCoordsSlot(srlj[[jj]])
#			    pip[jj] <- point.in.polygon(ixc, iyc, crds[,1], 
#				crds[,2])
#			} # jj
#			int[j] <- any((pip == 1) | (pip > 1))
#
# when pip == 1, the first point is fully included in the polygon, for
# pip > 1, the point lies on the polygon boundary, so the relative ring 
# directions need to be checked too. This can still go wrong when the
# ring directions are wrong (maybe not just then).
#
#		    } # j
#		    rj <- ri[int]
#		    if (length(rj) > 0) {
#		        res1[[i]] <- as.integer(rj)
#		    }
#		} # ii
#	    } # !is.null
#	} # i
#	res1
#}

#.afters <- function(rl) {
#
# argument is output from .insiders() - a list with either NULL components 
# (not included in any other polygon) or lists of polygons in which the polygon
# in question is included; outputs a from:to matrix
#
#	n <- length(rl)
#	res <- NULL
#	for (i in 1:n) {
#		if (is.null(rl[[i]]))
#			res <- rbind(res, c(i, NA))
#		else {
#			for (j in 1:length(rl[[i]])) {
#				res <- rbind(res, c(i, rl[[i]][j]))
#			}
#		}
#	}
#	res
#}


#.lbuild <- function(x, rD) {
#
# list analysis of matrix output from .afters combined with current ring
# directions (which may be quite wrong) to generate a plot order and 
# vector of afters (NA for no dependency, 1 for dependency on being plotted
# after another polygon)
#
#	ids <- x[,1]
#	ins <- x[,2]
#	n <- length(unique(ids))
#	nas <- which(is.na(ins))
#	ntop <- length(nas)
#	pO <- vector(length=n, mode="integer")
#	after <- rep(as.integer(NA), length=n)
#	gone <- rep(FALSE, n)
#	j <- 1
#	for (i in 1:ntop) {
#		ii <- ids[nas[i]]
#		if (!gone[ii]) {
#			gone[ii] <- TRUE
#			pO[j] <- ii
#			j <- j+1
#		} else warning(paste("level 1 circularity at", ii))
#		ihits <- which(ins == ii)
#
# for each top level (not inside any other) polygon, check to see if any
# polygons are inside it, and insert orders to match; from outer to deepest in;
# the gone vector is used to avoid multiple assignments to the plot
# order list that can happen with circularity
#
#		if (length(ihits) > 0) {
#			tihits <- ids[ihits]
#			rtihits <- rle(ids[ids %in%tihits])
#			o <- order(rtihits$lengths)
#			for (jj in 1:length(rtihits$values)) {
#				jjj <- rtihits$values[o][jj]
#				if (!gone[jjj]) {
#					gone[jjj] <- TRUE
#					pO[j] <- jjj
#					j <- j+1
#				} else warning(paste("level 2 circularity at", 
#					jjj))
#				after[jjj] <- as.integer(1)
#			}
#		}
#	}
#	xcircs <- .circs(.lbuild1(x))
#
# Further attempts to trap circularities, possibly no longer needed, first
# introduced before point-in-polygon test added to .insiders; TODO check
# whether is.null(xcircs) is always TRUE
#
#	if (!is.null(xcircs)) {
#		for (i in 1:nrow(xcircs)) {
#			from <- xcircs[i,1]
#			to <- xcircs[i,2]
#			rDfrom <- rD[from]
#			rDto <- rD[to]
#			pOfrom <- which(pO == from)
#			pOto <- which(pO == to)
#			if (rDfrom == 1) {
#				if (pOfrom < pOto) {
#					pO[pOto] <- from
#					pO[pOfrom] <- to
#				}
#			}
#			if (rDto == 1) {
#				if (pOfrom > pOto) {
#					pO[pOto] <- from
#					pO[pOfrom] <- to
#				}
#			}			
#		}
#	}
#	list(pO=pO, after=after)
#}


#.circs <- function(x) {
#
# try to find circularities from reverse list as argument (polygons reported
# as being inside each other despite checking ring direction in .insiders);
# only the first loop will be run in normal cases
#
#	res <- NULL
#	for (i in 1:length(x)) {
#		if (!is.na(match(i, unlist(x[x[[i]]])))) {
#			hits <- rep(FALSE, length(x[[i]]))
#			for (j in 1:length(hits)) {
#				jj <- x[[i]][j]
#				hits[j] <- (i %in% x[[jj]])
#			}
#			if (length(which(hits)) > 1) stop("multiple circulars")
#			pair <- c(i, x[[i]][hits])
#			res <- rbind(res, pair)
#		}			
#	}
#	res1 <- NULL
#	if (!is.null(res)) {
#		if (nrow(res) %% 2 != 0) stop("odd circulars")
#		gone <- rep(FALSE, nrow(res))
#		for (i in 1:nrow(res)) {
#			if (!gone[i]) {
#				from <- res[i,1]
#				to <- res[i,2]
#				hit <- match(from, res[,2])
#				if (!gone[hit]) {
#					if (res[hit,1] != to) 
#						stop("mismatched circular")
#					res1 <- rbind(res1, c(from, to))
#					gone[i] <- TRUE
#				}
#			}
#		}
#	}
#	res1
#}

#.lbuild1 <- function(x) {
#
# reverse list builder with from:to matrix as argument, used to try to find
# circularities
#
#	lx <- vector(mode="list", length=length(unique(x[,1])))
#	rle.x <- rle(x[,1])
#	cs1.x <- cumsum(rle.x$lengths)
#	cs0.x <- c(1, cs1.x[1:(length(lx)-1)]+1)
#	ii <- 1
#	for (i in 1:length(lx)) {
#		if (rle.x$value[ii] == i) {
#			lx[[i]] <- as.integer(x[cs0.x[ii]:cs1.x[ii],2])
#			ii <- ii+1
#		}
#	}
#	lx
#}

#.checkRD1 <- function(pO, after, rD, xyList, verbose=TRUE) {
#	top <- which(pO == 1)
#	if (any((rD[-top] == -1) & is.na(after[-top]))) {
#		oddCC <- which((rD == -1) & is.na(after))
#		for (i in oddCC) {
#			if (i != top) {
#				xyList[[i]] <- xyList[[i]][nrow(xyList[[i]]):1,]
#				if (verbose) 
#					warning(paste("ring direction changed in subpolygon"))
#			}
#		}
#	}
#	xyList
#}

#.checkRD2 <- function(pO, after, rD, srl) {
#	top <- which(pO == 1)
#	if (any((rD[-top] == -1) & is.na(after[-top]))) {
#		oddCC <- which((rD == -1) & is.na(after))
#		for (i in oddCC) {
#			if (i != top) {
#				crds <- getSringCoordsSlot(srl[[i]])
#				projargs <- proj4string(srl[[i]])
#				srl[[i]] <- Sring(coords=crds[nrow(crds):1,], 
#					proj4string=CRS(projargs))
#				warning(paste("ring direction changed in subpolygon in polygon", i))
#			}
#		}
#	}
#	srl
#}

.saneRD <- function(rD) {
	if (length(rD) == 0) stop("Not a valid polygon: rD length 0")
	if (any(is.na(rD))) stop("Not a valid polygon: NA rD value")
	if (any(abs(rD) != 1)) stop("Not a valid polygon: abs(rD) != 1")
	invisible(NULL)
}

.RingCentrd_2d <- function(plmat) {
	nVert <- nrow(plmat)
	x_base <- plmat[1,1]
	y_base <- plmat[1,2]
	Cy_accum <- 0.0
	Cx_accum <- 0.0
	Area <- 0.0
	ppx <- plmat[2,1] - x_base
	ppy <- plmat[2,2] - y_base
	for (iv in 2:(nVert-1)) {
		x = plmat[iv,1] - x_base
		y = plmat[iv,2] - y_base
		dx_Area <-  ((x * ppy) - (y * ppx)) * 0.5
		Area <- Area + dx_Area
		Cx_accum <- Cx_accum + ( ppx + x ) * dx_Area      
		Cy_accum <- Cy_accum + ( ppy + y ) * dx_Area
		ppx <- x
		ppy <- y
	}
	xc <- (Cx_accum / (Area * 3)) + x_base
	yc <- (Cy_accum / (Area * 3)) + y_base
	list(xc=xc, yc=yc, area=abs(Area))	
}

#.RingCentrd_2d <- function(plmat) {
#	nVert <- nrow(plmat)
#	x_base <- plmat[1,1]
#	y_base <- plmat[1,2]
#	Cy_accum <- 0.0
#	Cx_accum <- 0.0
#	Area <- 0.0
#	ppx <- plmat[2,1] - x_base
#	ppy <- plmat[2,2] - y_base
#	for (iv in 2:(nVert-2)) {
#		x = plmat[iv,1] - x_base
#		y = plmat[iv,2] - y_base
#		dx_Area <-  ((x * ppy) - (y * ppx)) * 0.5
#		Area <- Area + dx_Area
#		Cx_accum <- Cx_accum + ( ppx + x ) * dx_Area      
#		Cy_accum <- Cy_accum + ( ppy + y ) * dx_Area
#		ppx <- x
#		ppy <- y
#	}
#	xc <- (Cx_accum / (Area * 3)) + x_base
#	yc <- (Cy_accum / (Area * 3)) + y_base
#	list(xc=xc, yc=yc, area=Area)	
#}

