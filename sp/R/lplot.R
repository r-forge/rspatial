"lplot" <-
function (data, zcol, names.attr, col.regions = bpy.colors(), expand = 0.03,...) 
{
	# data = as(data, "SpatialPointsDataFrame")
	if (!extends(class(data), "SpatialPointsDataFrame")) 
		stop("data is not of a class that extends SpatialPointsDataFrame")
	if (extends(class(data), "SpatialRingsDataFrame")) {
		pol = rings(data)
		data = as(data, "SpatialPointsDataFrame")
	} else
		pol = NULL
	if (missing(zcol)) 
		zcol = names(data@data)[1]
	if (length(zcol) > 1) {
		formula = as.formula(paste("z~", paste(dimnames(data@coords)[[2]], 
			collapse = "+"), "|name"))
		data = map.to.lev(data, zcol = zcol, names.attr = names.attr)
		#data = stack(data, zcol)
	} else {
		if (!is.character(zcol)) 
			stop("zcol should be a character vector")
		formula = as.formula(paste(zcol, "~", paste(dimnames(data@coords)[[2]],
			collapse = "+")))
	}
#ifdef R
	require(lattice)
#endif
	#asp = mapasp(data)
	asp = "iso"
	if (!is.null(pol)) {
#ifdef R
		require(grid)
#endif
		if (version$major >= 2) {
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
				plotPol = function(x, idx) {
					from = x@pStart.from
					to = x@pStart.to
					coords = na.omit(x@coords)
					nparts = x@nParts
					id.lengths = (to - 0:(nparts-1)) - (from - 1:nparts)
					grid.polygon(coords[,1], coords[,2], id.lengths=id.lengths,
						default.units = "native", 
						gp = gpar(fill = col.regions[zcol[idx]], col = NULL,
							alpha = alpha.regions))
				}
				if (any(subscripts))
					for (i in 1:length(grid.polygons@polygons))
						plotPol(grid.polygons@polygons[[i]], i)
			}
		} else {
		"panel.lplot" <-
			function (x, y, z, zcol, subscripts, at = mean(z), shrink, labels = NULL, 
				label.style = c("mixed", "flat", "align"), contour = TRUE, 
				region = TRUE, col = add.line$col, lty = add.line$lty, lwd = add.line$lwd, 
				cex = add.text$cex, font = add.text$font, fontfamily = 
				add.text$fontfamily, fontface = add.text$fontface, col.text = add.text$col,
				..., col.regions, grid.polygons) 
			{
				label.style <- match.arg(label.style)
				x <- as.numeric(x[subscripts])
				y <- as.numeric(y[subscripts])
				z <- as.numeric(z[subscripts])
				zcol <- as.numeric(zcol[subscripts])
				plotPol = function(x, idx) {
					from = x@pStart.from
					to = x@pStart.to
					coords = na.omit(x@coords)
					nparts = x@nParts
					id.lengths = (to - 0:(nparts-1)) - (from - 1:nparts)
					grid.polygon(coords[,1], coords[,2], id.lengths=id.lengths,
						default.units = "native", 
						gp = gpar(fill = col.regions[zcol[idx]], col = NULL))
				}
				if (any(subscripts))
					for (i in 1:length(grid.polygons@polygons))
						plotPol(grid.polygons@polygons[[i]], i)
			}
		}
		expand.bbox = function(range, value) {
			r = diff(range)
			range[1] = range[1] - value * r 
			range[2] = range[2] + value * r 
			range
		}
		levelplot(formula, as.data.frame(data), aspect = asp,
			col.regions = col.regions, grid.polygons = pol, 
			panel = panel.lplot, xlim = expand.bbox(bbox(data)[1,], expand), 
			ylim = expand.bbox(bbox(data)[2,], expand), ...)
	} else 
		levelplot(formula, as.data.frame(data), aspect = asp,
			col.regions = col.regions, ...)
}
