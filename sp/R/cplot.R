"cplot" <- function (obj, zcol = 1, fill = TRUE, pch, 
	col = bpy.colors(ifelse(length(cuts)>1, length(cuts)-1, cuts)), 
	cex = 1, cuts = 5, main = ifelse(is.numeric(zcol), names(data)[zcol], zcol),
    identify = FALSE, labels = row.names(data.frame(obj)), do.log =
    FALSE, ...)
{
    if (!is(obj, "SpatialPoints"))
        stop("first object is not of (or does not extend) class SpatialPoints")
    cc = coordinates(obj)
	if (is(obj, "SpatialPointsDataFrame"))
    	data = obj@data
	else
		data = data.frame(Var1=rep(1,nrow(cc)))
    x = cc[, 1]
    y = cc[, 2]
    if (NCOL(data) == 1) 
        z = data
    else if (NCOL(data) == 0) 
        z = rep(1, NROW(cc))
    else {
		if (is.character(zcol))
			z = model.frame(as.formula(paste(zcol, "~1")) , data)[[1]]
		else
			z = data[, zcol]
	}
    if (missing(pch)) 
        pch = ifelse(fill, 16, 1)
	if (length(cuts) == 1 && do.log) {
		lz = log(z)
		cuts = c(min(z), exp(seq(min(lz), max(lz), length=cuts+1))[2:(cuts)], max(z))
	}
    groups = cut(as.matrix(z), cuts, dig.lab=4, include.lowest=TRUE)

    if (identify) {
		stop("does not work yet")
        plot(x, y, asp = 1, cex = cex, main = main, col = groups,...)
        return(identify(x, y, labels))
    } else {
        require(lattice)
		n = length(levels(groups))
        key = list(space = "right", points = list(pch = rep(pch, n), 
            col = col, cex = rep(cex, n)), text = list(levels(groups)))
        xyplot(y ~ x, groups = groups,
			col = col, cex = cex, pch = pch, asp = mapasp(obj), 
            key = key, main = main, ...)
    }
}
