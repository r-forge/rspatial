"map.to.lev" <-
function (data, zcol = 1:n, n = 2, names.attr) 
{
	if (!extends(class(data), "SpatialDataFrame"))
		stop("data is not of a class that extends SpatialDataFrame")

	if (spatial.dimension(data) == 3)
		stop("map.to.lev only works for 2D data")
	coord.names = data@coord.names

	data = stack(data, zcol)
	if (!missing(names.attr)) {
		if (length(names.attr) != length(zcol))
			stop("length names.attr should match length of zcol")
		data@data$ind = factor(as.integer(data@data$ind), labels = names.attr)
	}

    d = data.frame(data)
    names(d) = c(coord.names, "z", "name")
    d
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
   	cc = coordinates(x)

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
	names(ccr) = x@coord.names
	x@data = data.frame(ccr, values = unlist(unname(xd)),
		ind = factor(rep(names(xd), lapply(xd, length)), 
			levels = names(xd)))
	x
}
