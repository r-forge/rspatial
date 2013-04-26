# Robert Hijmans:
.explode <- function(x, df=FALSE) {
	npols <- length(x@polygons)
	crs <- x@proj4string
	count <- 0
	p <- NULL
	np <- vector(length=npols)
	for (i in npols) {
		parts <- x@polygons[[i]]@Polygons
		np[i] <- length(parts)
		p <- c(p, sapply(1:np[i], function(x) Polygons(parts[x], x+count)))
	}
	p <- SpatialPolygons(p)
	p@proj4string <- crs
	if (df) {
		if (.hasSlot(x, 'data')) {
			np <- rep(1:npols, np)
			x <- x@data[np,]
			rownames(x) <- 1:nrow(x)
			p <- SpatialPolygonsDataFrame(p, data=x)
		}
	}
	p
}

# Roger, claims Barry wrote it first:
unfold = function(x) {
	crds <- coordinates(x)
	nobjs <- sum(sapply(crds, length))
	out <- vector(mode="list", length=nobjs)
	i <- 1
	for (j in seq(along=crds)) {
  		jcrds <- crds[[j]]
  		for (k in seq(along=jcrds)) {
    		out[[i]] <- Lines(list(Line(jcrds[k])), as.character(i))
    		i <- i + 1
  		}
	}
	SLout <- SpatialLines(out)
	length(SLout) 
}
