"lplot" <- 
function(data, zcol, names.attr, col.regions = bpy.colors(), ...) {
	if (!extends(class(data), "SpatialDataFrame"))
		stop("data is not of a class that extends SpatialDataFrame")
	if (missing(zcol))
		zcol = names(data@data[,-coordinates(data, "columns")])[1]
	if (length(zcol) > 1) {
		data = map.to.lev(data, zcol = zcol, names.attr = names.attr, df = FALSE)
		formula = as.formula(paste("z~", paste(coordinates(data, "names"), 
			collapse="+"), "|name"))
	} else {
		if (!is.character(zcol))
			stop("zcol should be a character vector")
		formula = as.formula(paste(zcol, "~", paste(coordinates(data, "names"), 
			collapse="+")))
	}
	levelplot(formula, as.data.frame(data), asp = mapasp(data), 
		col.regions = col.regions, ...)
}

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
