sp.polygon = function(obj, col = 1, ...) {
	sp.polygon3 = function(x, ...) { 
		cc = getSringCoordsSlot(x)
		grid.polygon(cc[,1], cc[,2], default.units = "native", 
			gp = gpar(col = col, ...))
		panel.lines(cc, col = col, ...)
	}
	if (!is(obj, "SpatialRings"))
		stop(paste("object extending class SpatialRings expected; got class", class(obj)))
	else
		obj = as(obj, "SpatialRings")
	pls = getSRpolygonsSlot(obj)
   	pO <- getSRplotOrderSlot(obj)
	require(grid)
   	for (i in pO) {
   		Srs <- getSringsSringsSlot(pls[[i]])
   		pOi <- getSringsplotOrderSlot(pls[[i]])
   		for (j in pOi)
			sp.polygon3(Srs[[j]], ...)
	}
}

sp.lines = function(obj, col = 1, ...) {
	sp.lines3 = function(x, ...) panel.lines(coordinates(x), col = col, ...)
	sp.lines2 = function(x, ...) lapply(x@Slines, sp.lines3, col = col, ...)
	if (is(obj, "SpatialLines"))
		lapply(obj@lines, sp.lines2, col = col, ...)
	else if (is(obj, "Slines"))
		lapply(obj@Slines, sp.lines3, col = col, ...)
	else if (is(obj, "Sline"))
		panel.lines(coordinates(obj), col = col, ...)
	else stop(paste("obj of class Sline, Slines or SpatialLines expected, got", class(obj)))
}

sp.text = function(loc, txt, ...) {
	if (length(loc) != 2)
		stop("loc should have length 2")
	panel.text(loc[1], loc[2], txt, ...)
}

sp.points = function(obj, ...) {
	xy = coordinates(obj)
	panel.points(xy[,1], xy[,2], ...)
}

sp.panel.layout = function(lst, ...) {
	sp.panel0 = function(x, ...) {
		if (inherits(x, "list")) {
			n = length(x)
			do.call(x[[1]], x[2:n])
		} else if (is(x, "SpatialLines") || is(x, "Slines") || is(x, "Sline"))
			sp.lines(x, ...)
		else if (is(x, "SpatialPoints"))
			sp.points(x, ...)
		else if (is(x, "SpatialRings"))
			sp.polygon(x, ...)
		else stop(paste("cannot plot object of class", class(x)))
	}
	if (is.null(lst))
		return()
	if (inherits(lst, "list")) {
		if (inherits(lst[[1]], "list")) 
			lapply(lst, sp.panel0, ...)
		else
			sp.panel0(lst, ...)
	} else
		stop(paste("expected object of class list; got object of class", class(lst)))
}

spplot <- function(obj, zcol, ..., names.attr, col.regions = bpy.colors(), 
		sp.layout = NULL) {

	require(lattice)
	if (is(obj, "SpatialRingsDataFrame")) {
		require(grid)
		xr = bbox(obj)[1, ] 
		yr = bbox(obj)[2, ]
		labpts = getSRSringsLabptSlots(obj)
		dimnames(labpts)[[2]] = c("x", "y")
		sdf = data.frame(cbind(labpts, obj@data))
		coordinates(sdf) = c("x", "y")
	} else if (gridded(obj)) {
		obj = as(obj, "SpatialPointsDataFrame")
		sdf = obj
	} else if (is(obj, "SpatialPointsDataFrame"))
		return(cplot(obj, zcol, col.regions = col.regions, 
			sp.layout = sp.layout, ...))
	else
		stop(paste("spplot: no plotting method for object of class", class(obj)))

	asp = mapasp(obj)
	if (missing(zcol)) 
		zcol = names(obj)
	if (length(zcol) > 1) {
		formula = as.formula(paste("z~", paste(dimnames(coordinates(sdf))[[2]], 
			collapse = "+"), "|name"))
		sdf = map.to.lev(sdf, zcol = zcol, names.attr = names.attr)
	} else {
		if (!is.character(zcol)) 
			stop("zcol should be a character vector")
		formula = as.formula(paste(zcol, "~", paste(dimnames(coordinates(sdf))[[2]],
			collapse = "+")))
	}

	if (is(obj, "SpatialRingsDataFrame"))
		levelplot(formula, as(sdf, "data.frame"), aspect = asp,
			col.regions = col.regions, grid.polygons = as(obj, "SpatialRings"), 
			panel = panel.lplot, xlim = xr, ylim = yr, sp.layout = sp.layout, ...)
	else
		levelplot(formula, as(obj, "data.frame"), aspect = asp,
			col.regions = col.regions, ...)
}

spplot.key = function(sp.layout, row = 1, col = 1) {
	for (i in seq(along=row)) {
		for (j in seq(along=col)) {
			trellis.focus("panel", col[j], row[i], highlight = FALSE)
			sp.panel.layout(sp.layout)
			trellis.unfocus()
		}
	}
}

"panel.lplot" <-
function (x, y, z, subscripts, at = pretty(z), shrink, labels = NULL, 
   		label.style = c("mixed", "flat", "align"), contour = FALSE, 
   		region = TRUE, col = add.line$col, lty = add.line$lty, lwd = add.line$lwd, 
   		cex = add.text$cex, font = add.text$font, fontfamily = add.text$fontfamily, 
   		fontface = add.text$fontface, col.text = add.text$col, ..., 
   		col.regions = regions$col, alpha.regions = regions$alpha, 
		grid.polygons, sp.layout) 
{
	regions <- trellis.par.get("regions")
	numcol <- length(at) - 1
	numcol.r <- length(col.regions)
	col.regions <- if (numcol.r <= numcol) 
   			rep(col.regions, length = numcol)
   		else col.regions[floor(1 + (1:numcol - 1) * (numcol.r - 1)/(numcol - 1))]
	zcol <- rep(NA, length(z))
	for (i in seq(along = col.regions)) zcol[!is.na(x) & !is.na(y) & 
      			!is.na(z) & z >= at[i] & z < at[i + 1]] <- i
	label.style <- match.arg(label.style)
	x <- as.numeric(x[subscripts])
	y <- as.numeric(y[subscripts])
	z <- as.numeric(z[subscripts])
	zcol <- as.numeric(zcol[subscripts])
	if (any(subscripts)) {
		pls = getSRpolygonsSlot(grid.polygons)
   		pO <- getSRplotOrderSlot(grid.polygons)
   		for (i in pO) {
       		Srs <- getSringsSringsSlot(pls[[i]])
       		pOi <- getSringsplotOrderSlot(pls[[i]])
       		for (j in pOi) {
				coords = getSringCoordsSlot(Srs[[j]])
				grid.polygon(coords[,1], coords[,2], #id.lengths=id.lengths,
					default.units = "native", 
					gp = gpar(fill = col.regions[zcol[i]], col = NULL,
						alpha = alpha.regions))
				panel.lines(coords, col = 1)
			}
   		}
	}
	sp.panel.layout(sp.layout)
}

"cplot" <-
function (obj, zcol = 1, cuts = 5, ..., groups, fill = TRUE, pch, col,
	cex = 1, main = ifelse(is.numeric(zcol), names(data)[zcol],
	zcol), identify = FALSE, labels = row.names(data.frame(obj)),
    do.log = FALSE, legend, key.space = "right", sp.layout = NULL)
{
	if (missing(groups))
		panel.cplot = function(x, y, subscripts, col, ...) {
			panel.xyplot(x, y, subscripts, col = col, ...)
			sp.panel.layout(sp.layout)
			print(cbind(x,y,subscripts))
		}
	else
		panel.cplot = function(x, y, subscripts, ...) {
			panel.superpose(x, y, subscripts, ...)
			sp.panel.layout(sp.layout)
		}
    if (!is(obj, "SpatialPoints")) 
        stop("first object is not of (or does not extend) class SpatialPoints")
    cc = coordinates(obj)
    if (is(obj, "SpatialPointsDataFrame")) 
        data = as(obj, "data.frame")
    else data = data.frame(Var1 = rep(1, nrow(cc)))
    x = cc[, 1]
    y = cc[, 2]
    if (NCOL(data) == 1) 
        z = data
    else if (NCOL(data) == 0) 
        z = rep(1, NROW(cc))
    else {
        if (is.character(zcol)) 
            z = model.frame(as.formula(paste(zcol, "~1")), data)[[1]]
        else z = data[, zcol, drop = TRUE]
    }
    if (missing(pch)) 
        pch = ifelse(fill, 16, 1)
	if (missing(groups)) {
		if (missing(col))
			col = bpy.colors(ifelse(length(cuts) > 1, length(cuts) - 1, cuts))
    	if (length(cuts) == 1 && do.log) {
        	lz = log(z)
        	cuts = c(min(z), exp(seq(min(lz), max(lz), length = cuts + 
            	1))[2:(cuts)], max(z))
    	}
    	groups = cut(as.matrix(z), cuts, dig.lab = 4, include.lowest = TRUE)
		if (missing(legend))
			legend = levels(groups)
		n = length(levels(groups))
		key = list(space = key.space, points = list(pch = rep(pch, 
			n), col = col, cex = rep(cex, n)), text = list(legend))
		plt = xyplot(y ~ x, groups = groups, col = col, cex = cex, 
			pch = pch, asp = mapasp(obj), key = key, main = main, 
			panel = panel.cplot, ...)
		print("here")
	} else 
		plt = xyplot(y ~ x, groups = groups, col = col, cex = cex, 
			pch = pch, asp = mapasp(obj), key = key, main = main, 
			panel = panel.cplot, ...)
	if (identify && interactive()) {
		print(plt)
		trellis.focus("panel", 1, 1)
		cat("left-mouse to identify points; right-mouse to end\n")
		ret = panel.identify(x, y, labels)
		trellis.unfocus()
		return(ret)
	} else
		return(plt)
}


SpatialRings2Grob = function(obj, fill) {
	if (!is(obj, "SpatialRings"))
		stop("object is not of class SpatialRings")
	x = numeric(0)
	y = numeric(0)
	id = integer(0)
	pls = getSRpolygonsSlot(obj)
   	pO <- getSRplotOrderSlot(obj)
	n = 0
   	for (i in pO) {
   		Srs <- getSringsSringsSlot(pls[[i]])
   		pOi <- getSringsplotOrderSlot(pls[[i]])
   		for (j in pOi) {
			n = n + 1
			cc = getSringCoordsSlot(Srs[[j]])
			x = c(x, cc[,1])
			y = c(y, cc[,2])
			id = c(id, rep(n, nrow(cc)))
		}
	}
	polygonGrob(x=x, y=y, id=id, gp = gpar(fill = fill))
}

SpatialRingsRescale = function(obj, offset, scale = 1, fill = "black", col = "black",...) {
	if (!is(obj, "SpatialRings"))
		stop("object is not of class SpatialRings")
	if (length(offset) != 2)
		stop("offset should have length 2")
	if (length(scale) == 1)
		scale = rep(scale,2)
	pls = getSRpolygonsSlot(obj)
   	pO = getSRplotOrderSlot(obj)
	fill = rep(fill, length = length(pls))
   	for (i in pO) {
   		Srs <- getSringsSringsSlot(pls[[i]])
   		pOi <- getSringsplotOrderSlot(pls[[i]])
   		for (j in pOi) {
			cc = getSringCoordsSlot(Srs[[j]])
			x = offset[1] + (cc[,1] * scale[1])
			y = offset[2] + (cc[,2] * scale[2])
			grid.polygon(x, y, default.units = "native", 
				gp = gpar(col = col, fill = fill[i], ...))
		}
	}
}

mapLegendGrob <- function(obj, widths = unit(1, "cm"), heights = unit(1, "cm"),
		fill = "black", just = "right") {
	grb = SpatialRings2Grob(obj, fill)
	key.layout <- grid.layout(nrow = 1, ncol = 1, widths = widths,
					heights = heights, respect = TRUE, just = just)
	key.gf <- frameGrob(layout = key.layout)
	key.gf <- placeGrob(key.gf,
				  rectGrob(gp = gpar(fill = "transparent", col = NULL)),
				  row = NULL, col = NULL)
	key.gf <- placeGrob(key.gf, grb, row = 1, col = 1)
	key.gf
}
