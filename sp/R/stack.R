"map.to.lev" <- function (data, zcol = 1:n, n = 2, names.attr)
{
	if (!extends(class(data), "SpatialPointsDataFrame") &&
			!extends(class(data), "SpatialCellDataFrame"))
		stop("data is not of a class that extends SpatialPointsDataFrame or SpatialCellDataFrame")

	if (dimensions(data) == 3)
		stop("map.to.lev only works for 2D data")
	coord.names = dimnames(data@coords)[[2]]

	data = stack(as(data, "SpatialPointsDataFrame"), zcol) # replace with data.frame
	if (!missing(names.attr)) {
		if (length(names.attr) != length(zcol))
			stop("length names.attr should match length of zcol")
		data$ind = factor(as.integer(data$ind), labels = names.attr)
	}
	names(data) = c(coord.names, "z", "name")
	data
}

## Let's see if this is needed, or whether it gets called automatically:
#stack.SpatialCellDataFrame = function (x, select, ...) {
#	stack(as(x, "SpatialPointsDataFrame"), select, ...)
#}

stack.SpatialPointsDataFrame = function (x, select, ...)
# inspired heavily on stack.data.frame...
{
	xd = x@data
   	cc = coordinates(x)
	cc.names = dimnames(cc)[[2]]

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
	ccr = data.frame(rep(cc[,1], ncol(xd)))
	for (i in 2:ncol(cc))
		ccr = data.frame(ccr, rep(cc[,i], ncol(xd)))
	names(ccr) = cc.names
	data.frame(ccr, values = unlist(unname(xd)),
		ind = factor(rep(names(xd), lapply(xd, length)), 
			levels = names(xd)))
}

stack.SpatialGridDataFrame = function (x, select, ...) {
	stack(as(x, "SpatialPointsDataFrame"), select, ...)
}
