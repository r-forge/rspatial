# Copyright (c) 2003 by Barry Rowlingson and Roger Bivand

"project" <- function(xy, proj, inv=FALSE) {

    if (!is.numeric(xy)) stop("xy not numeric")
    if (is.matrix(xy)) nc <- dim(xy)[1]
    else if (length(xy) == 2) nc <- 1
    else stop("xy malformed")
    if(!inv) {
      res <- .C("project",
                as.integer(nc),
                as.double(xy[,1]),
                as.double(xy[,2]),
                x=double(nc),
                y=double(nc),
                proj,
                NAOK=TRUE,
                PACKAGE="sp")
    } else {
      res <- .C("project_inv",
                as.integer(nc),
                as.double(xy[,1]),
                as.double(xy[,2]),
                x=double(nc),
                y=double(nc),
                proj,
                NAOK=TRUE,
                PACKAGE="sp")
    }
    cbind(res$x, res$y)
}

"transform.SpatialDataFrame" <- function(x, CoRSobj, ...) {

	if (is.na(x@proj4string@projargs)) 
		stop("No transformation possible from NA reference system")
	if (is.na(CoRSobj@projargs)) 
		stop("No transformation possible to NA reference system")
	crds <- coordinates(x)
	if (ncol(crds) != 2) stop("Only 2D coordinates can be transformed")
	n <- nrow(crds)
	res <- .Call("transform", proj4string(x), CoRSargs(CoRSobj), n,
		as.double(crds[,1]), as.double(crds[,2]),
		PACKAGE="sp")
	# make sure x coordinate names are set back:
	crds.names <- names(crds)
	crds <- data.frame(res[[1]], res[[2]])
	coordinates(x) <- crds
	x@coord.names <- crds.names
	proj4string(x) <- CoRS(res[[4]])
	x
}

setMethod("transform", signature("SpatialDataFrame", "CoRS"), transform.SpatialDataFrame)

"transform.Polylist4" <- function(x, CoRSobj, ...) {

	if (is.na(x@proj4string@projargs)) 
		stop("No transformation possible from NA reference system")
	if (is.na(CoRSobj@projargs)) 
		stop("No transformation possible to NA reference system")
	n <- length(x@polygons)
	plgs <- vector(mode="list", length=n)

	for (i in 1:n) plgs[[i]] <- transform(x@polygons[[i]], CoRSobj)

	xx <- sapply(plgs, function(x) (x@bbox))
	bbox <- rbind(range(xx[c(1,3),]), range(xx[c(2,4),]))
	rownames(bbox) <- c("x", "y")
	colnames(bbox) <- c("min", "max")

	SD <- new("SpatialData", bbox=bbox, proj4string=CoRSobj)

	res <- new("Polylist4", SD, polygons=plgs, region.id=x@region.id, 
		within=x@within)
	res
}

setMethod("transform", signature("Polylist4", "CoRS"), transform.Polylist4)

"transform.Polygon4" <- function(x, CoRSobj, ...) {
	if (is.na(x@proj4string@projargs)) 
		stop("No transformation possible from NA reference system")
	if (is.na(CoRSobj@projargs)) 
		stop("No transformation possible to NA reference system")
	crds <- x@coords
	n <- nrow(crds)
	res <- .Call("transform", proj4string(x), CoRSargs(CoRSobj), n,
		as.double(crds[,1]), as.double(crds[,2]),
		PACKAGE="sp")
	
	bbox <- rbind(range(res[[1]], na.rm=TRUE), range(res[[2]], na.rm=TRUE))
	rownames(bbox) <- c("x", "y")
	colnames(bbox) <- c("min", "max")
	SD <- new("SpatialData", bbox=bbox, proj4string=CoRS(res[[4]]))
	P4 <- new("Polygon4", SD, coords=cbind(res[[1]], res[[2]]), 
		nVerts=x@nVerts, nParts=x@nParts, pStart.from=x@pStart.from, 
		pStart.to=x@pStart.to, RingDir=x@RingDir, ringDir=x@ringDir,
		region.id=x@region.id)
	P4
}

setMethod("transform", signature("Polygon4", "CoRS"), transform.Polygon4)

