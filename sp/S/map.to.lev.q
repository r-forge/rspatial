"map.to.lev" <-
function (data, zcol = 1:n, n = 2, names.attr, df = TRUE)
{
	if (!extends(class(data), "SpatialDataFrame"))
		stop("data is not of a class that extends SpatialDataFrame")

	if (spatial.dimension(data) == 3)
		stop("map.to.lev only works for 2D data")
	coord.names = coordinates(data, "names")

	data = stack(data, zcol)
	if (!missing(names.attr)) {
		if (length(names.attr) != length(zcol))
			stop("length names.attr should match length of zcol")
		data@data$ind = factor(as.integer(data@data$ind), labels = names.attr)
	}

	names(data@data) = c(coord.names, "z", "name")
	if (df)
		data@data
	else
		data
}

stack.SpatialDataFrameGrid = function (x, select, ...) {
	sdf = stack(as(x, "SpatialDataFrame"), select, ...)
	x@data = sdf@data
	x
}

stack.SpatialDataFrame = function (x, select, ...)
# inspired heavily on stack.data.frame...
{
	xd = x@data[, -x@coord.columns, drop = FALSE]
   	cc = coordinates(x, "values")
	cc.names = coordinates(x, "names")

	if (!missing(select)) {
		if (!is.numeric(select)) {
			nl = as.list(1:ncol(xd))
			names(nl) = names(xd)
			vars = eval(substitute(select), nl, parent.frame())
		} else
			vars = select
		xd = xd[, vars, drop = FALSE]
	}
	xd = xd[, unlist(lapply(xd, is.vector)), drop = FALSE]
	ccr = data.frame(rep(cc[,1], ncol(xd)), rep(cc[,2], ncol(xd)))
	if (spatial.dimension(x) == 3)
		ccr = data.frame(ccr, rep(cc[,3], ncol(xd)))
	names(ccr) = cc.names
	x@data = data.frame(ccr, values = unlist(unname(xd)),
		ind = factor(rep(names(xd), lapply(xd, length)), 
			levels = names(xd)))
	x
}

"lplot" <-
function (data, zcol, names.attr, col.regions = bpy.colors(), expand = 0.03,...) 
{
	if (!extends(class(data), "SpatialDataFrame")) 
		stop("data is not of a class that extends SpatialDataFrame")
	if (extends(class(data), "SpatialDataFramePolygons")) {
		pol = Polygons(data)
		data = as(data, "SpatialDataFrame")
	} else
		pol = NULL
	if (missing(zcol)) 
		zcol = names(data@data[, -coordinates(data, "columns")])[1]
	if (length(zcol) > 1) {
		data = map.to.lev(data, zcol = zcol, names.attr = names.attr, df = FALSE)
		formula = as.formula(paste("z~", paste(coordinates(data, 
			"names"), collapse = "+"), "|name"))
	}
	else {
		if (!is.character(zcol)) 
			stop("zcol should be a character vector")
		formula = as.formula(paste(zcol, "~", paste(coordinates(data, 
			"names"), collapse = "+")))
	}
#ifdef R
	require(lattice)
#endif
	asp = mapasp(data)
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
