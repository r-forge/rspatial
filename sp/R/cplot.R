"cplot" <-
function (obj, zcol = 1, cuts = 5, ..., fill = TRUE, pch, col, cex = 1,
	main = ifelse(is.numeric(zcol), names(data)[zcol], zcol), 
	identify = FALSE, labels = row.names(data.frame(obj)), 
    do.log = FALSE, legend, space = "right") 
{
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
        else z = data[, zcol]
    }
    if (missing(pch)) 
        pch = ifelse(fill, 16, 1)
	if (is.factor(z)) {
		groups = z
		if (missing(col)) {
			if (require(RColorBrewer))
				col = brewer.pal(length(levels(z)), "Set1")
			else
				col = bpy.colors(length(levels(z)))
		}
	} else {
		if (missing(col))
			col = bpy.colors(ifelse(length(cuts) > 1, length(cuts) - 1, cuts))
    	if (length(cuts) == 1 && do.log) {
        	lz = log(z)
        	cuts = c(min(z), exp(seq(min(lz), max(lz), length = cuts + 
            	1))[2:(cuts)], max(z))
    	}
    	groups = cut(as.matrix(z), cuts, dig.lab = 4, include.lowest = TRUE)
	}
	if (missing(legend))
		legend = levels(groups)
	n = length(levels(groups))
	key = list(space = "right", points = list(pch = rep(pch, 
		n), col = col, cex = rep(cex, n)), text = list(legend))
	plt = xyplot(y ~ x, groups = groups, col = col, cex = cex, 
		pch = pch, asp = mapasp(obj), key = key, main = main, ...)
	if (identify) {
		print(plt)
		trellis.focus("panel", 1, 1)
		cat("left-mouse to identify points; right-mouse to end\n")
		ret = panel.identify(x, y, labels)
		trellis.unfocus()
		return(ret)
	} else
		return(plt)
}

