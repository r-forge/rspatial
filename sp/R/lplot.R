"gridplot" <-
function (data, zcol, names.attr, col.regions = bpy.colors(), ...)  {
	if (!is(data, "SpatialPointsDataFrame")) 
		stop("data is not of a class that extends SpatialPointsDataFrame")
	data = as(data, "SpatialPointsDataFrame")
	asp = mapasp(data)
	if (missing(zcol)) 
		zcol = names(data)
	if (length(zcol) > 1) {
		formula = as.formula(paste("z~", paste(dimnames(coordinates(data))[[2]], 
			collapse = "+"), "|name"))
		data = map.to.lev(data, zcol = zcol, names.attr = names.attr)
		#data = stack(data, zcol)
	} else {
		if (!is.character(zcol)) 
			stop("zcol should be a character vector")
		formula = as.formula(paste(zcol, "~", paste(dimnames(coordinates(data))[[2]],
			collapse = "+")))
	}
	levelplot(formula, as.data.frame(data), aspect = asp,
		col.regions = col.regions, ...)
}

"ringplot" <-
function (data, zcol, names.attr, col.regions = bpy.colors(), ...) {

	if (!is(data, "SpatialRingsDataFrame"))
		stop("data of class SpatialRingsDataFrame expected")

	# get "fake" x/y points to satisfy levelplot; use label points for this:
	labpts = getSRSringsLabptSlots(data)
	dimnames(labpts)[[2]] = c("x", "y")
	sdf = data.frame(cbind(labpts, data@data))
	coordinates(sdf) = c("x", "y")
	xr = bbox(data)[1, ] 
	yr = bbox(data)[2, ]

	asp = mapasp(data)

	if (missing(zcol)) 
		zcol = names(data@data)[1]
	if (length(zcol) > 1) {
		formula = as.formula(paste("z~", paste(dimnames(coordinates(sdf))[[2]], 
			collapse = "+"), "|name"))
		sdf = map.to.lev(sdf, zcol = zcol, names.attr = names.attr)
		#data = stack(data, zcol)
	} else {
		if (!is.character(zcol)) 
			stop("zcol should be a character vector")
		formula = as.formula(paste(zcol, "~", paste(dimnames(coordinates(sdf))[[2]],
			collapse = "+")))
	}
	"panel.lplot" <-
	function (x, y, z, subscripts, at = pretty(z), shrink, labels = NULL, 
   		label.style = c("mixed", "flat", "align"), contour = FALSE, 
   		region = TRUE, col = add.line$col, lty = add.line$lty, lwd = add.line$lwd, 
   		cex = add.text$cex, font = add.text$font, fontfamily = add.text$fontfamily, 
   		fontface = add.text$fontface, col.text = add.text$col, ..., 
   		col.regions = regions$col, alpha.regions = regions$alpha, 
		grid.polygons) 
	{
   		regions <- trellis.par.get("regions")
   		numcol <- length(at) - 1
   		numcol.r <- length(col.regions)
   		col.regions <- if (numcol.r <= numcol) 
      			rep(col.regions, length = numcol)
   		else col.regions[floor(1 + (1:numcol - 1) * (numcol.r - 1)/(numcol - 
      			1))]
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
					llines(coords, col = 1)
				}
    		}
		}
	}
	levelplot(formula, as(sdf, "data.frame"), aspect = asp,
		col.regions = col.regions, grid.polygons = as(data, "SpatialRings"), 
		panel = panel.lplot, xlim = xr, ylim = yr, ...)
}
