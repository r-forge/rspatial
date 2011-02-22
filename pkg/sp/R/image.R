# first argument of image generic _needs_ to be x!
image.SpatialPixelsDataFrame = function(x, ...)
	image(as(x, "SpatialGridDataFrame"), ...)

image.SpatialGridDataFrame = function(x, attr = 1, xcol = 1, ycol = 2,
                col = heat.colors(12), 
		red=NULL, green=NULL, blue=NULL, axes = FALSE, xlim = NULL, 
		ylim = NULL, add = FALSE, ..., asp = NA, 
		setParUsrBB=FALSE, interpolate = FALSE, angle = 0,
                useRasterImage=!.isSDI()) {

	if (!add)
		plot(as(x, "Spatial"),
			xlim = xlim, ylim = ylim, axes = axes, asp = asp, ..., 
			setParUsrBB=setParUsrBB)
        if (exists("rasterImage") && useRasterImage) {
            if (.isSDI()) warning("Bug in SDI raster handling - your R graphics window may stop displaying output")
            bb <- bbox(x)
            scl <- function(x) {
                dr <- diff(range(x, na.rm = TRUE))
                mx <- min(x, na.rm  = TRUE)
                if (abs(dr) < .Machine$double.eps)
                    res <- ifelse(is.na(x), x, 0.5)
                else res <- (x - mx) / dr
                res
            }
        }
	if (is.null(red)) {
            if (exists("rasterImage") && useRasterImage) {
                x <- x[attr]
#                NAs <- is.na(x[[1]])
                m <-  scl(t(matrix(x[[1]], x@grid@cells.dim[1],
                    x@grid@cells.dim[2])))
                m <- matrix(col[as.vector(m) * (length(col)-1) + 1], 
                    nrow(m), ncol(m))
                ## if missing, set to transparent
#                m[is.na(m)] <- rgb(1, 1, 1, 0)
                rasterImage(m, bb[1,1], bb[2,1], bb[1,2], bb[2,2],
                    interpolate = interpolate, angle = angle)
            } else {
		image(as.image.SpatialGridDataFrame(x[attr], xcol, ycol), 
                  add = TRUE, col = col, ...)
            }
	} else {
	    if (is.null(green) || is.null(blue)) 
		stop("all colour bands must be given")
# modified to handle NAs in input (typical for coercion of Spatial Pixels
# to Spatial Grid)
            if (exists("rasterImage") && useRasterImage) {
                xd <- x@data[, c(red, green, blue)]
                NAs <- is.na(xd[, 1]) | is.na(xd[, 2]) | is.na(xd[, 3])
                if (any(NAs))
                    xd <- xd[!NAs, ]
                ## create RGBs (using alpha=1 by default)
                RGBs <- rgb(xd, maxColorValue = 255)
                if (any(NAs)) {
                    z <- rep(NA, length(NAs))
                    z[!NAs] <- RGBs
                    RGBs <- z
                }
                cv <- coordinatevalues(getGridTopology(x))
                m <- t(matrix(RGBs, x@grid@cells.dim[1], 
                    x@grid@cells.dim[2], byrow = FALSE))
                rasterImage(m, bb[1,1], bb[2,1], bb[1,2], bb[2,2],
                    interpolate = interpolate, angle = angle)
            } else {
		xd <- x@data[,c(red, green, blue)]
		NAs <- is.na(xd[,1]) | is.na(xd[,2]) | is.na(xd[,3])
		if (any(NAs)) xd <- xd[!NAs,]
		RGBs <- rgb(xd, maxColorValue = 255)
		if (any(NAs)) {
		    z <- rep(NA, length(NAs))
		    z[!NAs] <- RGBs
		    RGBs <- z
		}
		fcols <- factor(RGBs)
		cv <- coordinatevalues(getGridTopology(x))
		m <- matrix(as.integer(fcols), x@grid@cells.dim[1], 
			x@grid@cells.dim[2], byrow=FALSE)
		res <- list(x=cv[[xcol]], y=sort(cv[[ycol]]), 
			z=m[,ncol(m):1,drop=FALSE])
		image(res, col=levels(fcols), add = TRUE, ...)
            }
	}
}

contour.SpatialGridDataFrame = function(x, attr = 1, xcol = 1, ycol = 2,
                col = 1, add = FALSE, xlim = NULL, ylim = NULL,
                axes = FALSE, ..., setParUsrBB = FALSE)  {
	if (!add)
		plot(as(x, "Spatial"),
			xlim = xlim, ylim = ylim, axes = axes, ..., 
			setParUsrBB=setParUsrBB)
	contour(as.image.SpatialGridDataFrame(x[attr], xcol, ycol), col = col,
          add = TRUE, ...)
}

contour.SpatialPixelsDataFrame = function(x, ...)
	contour(as(x, "SpatialGridDataFrame"), ...)

as.image.SpatialGridDataFrame = function(x, xcol = 1, ycol = 2, attr = 1) {
	cv = coordinatevalues(getGridTopology(x))
	m = as(x[attr], "matrix")
	list(x = cv[[xcol]], y = sort(cv[[ycol]]), z = m[,ncol(m):1,drop=FALSE])
}

# contributed by Michael Sumner 24 Oct 2007

image2Grid <- function (im, p4 = as.character(NA), digits=10) 
{
    if (!all(c("x", "y", "z") %in% names(im))) 
        stop("image must have components x, y, and z")
# RSB reversed test order
    lux <- length(unique(signif(diff(im$x), digits=digits)))
    luy <- length(unique(signif(diff(im$y), digits=digits)))
    if (lux > 1 || luy > 1) stop("x or y not equally spaced")
# RSB check for equal spacing
    cells.dim <- dim(im$z)
    xx <- im$x
    yy <- im$y
    lx <- length(xx)
    ly <- length(yy)
    if (all(c(lx, ly) == (cells.dim + 1))) {
        ##print("corners")
        if (!(lx == nrow(im$z) + 1 && ly == ncol(im$z) + 1 ) )
            stop("dimensions of z are not length(x)(-1) times length(y)(-1)")

        xx <- xx[-1] - diff(xx[1:2])/2
        yy <- yy[-1] - diff(yy[1:2])/2
    } else {

        if (!(lx == nrow(im$z) && ly == ncol(im$z)))
            stop("dimensions of z are not length(x) times length(y)")
    }

    SpatialGridDataFrame(GridTopology(c(xx[1], yy[1]), c(diff(xx[1:2]), 
        diff(yy[1:2])), cells.dim), data.frame(z = as.vector(im$z[, 
        ncol(im$z):1])), proj4string = CRS(p4))
}

# copied from the svMisc package, copyright Philippe Grosjean,
# Romain Francois & Kamil Barton
".isSDI" <- function()
{
	# This function is specific to Windows, but it is defined everywhere
	# so that we don't have to test the platform before use!
	# Check if Rgui was started in SDI mode (needed by some GUI clients)

	# 1) First is it Rgui?
	if (!.Platform$GUI[1] == "Rgui")
        return(FALSE)    # This is not Rgui

        # RGui SDI mode: returns "R Console", in MDI mode: returns "RGui"
        if (getIdentification() == "R Console") return(TRUE) else return(FALSE)

}