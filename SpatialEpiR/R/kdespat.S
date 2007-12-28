# Last modified: 10-8-00

kdespat <- function(pts, h, poly = NA, kernel = "normal", grid = T, x = NA,
                    y = NA, nx = NA, ny = NA, edge = T, scale = T,
                    innerpoly = NA, rings = 10, npt = 10*rings) {

# Julia Kelsall (1995)
# Calculates a spatial kernel density estimate of a point dataset - with and without
# edge-corrections, within a polygon or not, on a grid or not ... in other words
# a quite flexible function.
# pts        a point dataset
# h          a bandwidth parameter
# poly       a polygon containing the points
# kernel     a choice of kernel (either "normal" or "quartic")
# grid       logical value. If true, the estimate is calculated on a grid - this being
#            determined either by the specified x- and y-coordinates or by the sizes nx and ny
# x          if grid=T this (if stated) should be a vector of EQUALLY SPACED values that
#            cover the x-range of the data - used to construct the grid
#            if grid=F this should be a vector of x-coordinates which in combination with y
#            constitutes the points in which the estimate is calculated
# y          like x, but for the y-coordinates
# nx         if grid=T and x and y are not stated this specifies the size of the grid - if
#            it is not stated, the function does by default something sensible (at least 20
#            depending on the size of h - the smaller h the larger nx)
# ny         like nx
# edge       logical value. If true, edge-corrections are performed. However this is only
#            done if the POLYGON is SPECIFIED
# scale      logical value. If true, the estimate of the density will be scaled to integrate
#            to 1. Usually this is the case anyway and hence the scaling is often unnecessary!!
#            The option is only available if edge=T, grid=T and the grid is chosen fine enough.
# innerpoly  an inner polygon in which no edge-corrections are performed. This is optional but
#            only makes sense if edge=T. If the specified poly is not rectangular the
#            edge-corrections becomes much more computer intensive and this is then a way to
#            speed the process up - the philosophy being that the edge-corrections only negligible
#            affect the density estimate in the middle of the polygon. The smaller h the larger
#            the innerpoly can be. (Only really suitable for the "quartic" kernel)
# rings      the larger this number is the more accurate are the edge-corrections - the default
#            of 10 should be god enough in most cases. This option is only used if edge=T and
#            the poly is not rectangular
# npt        the larger this number is the more accurate are the edge-corrections - the default
#            should be adequate. Again this option is only used if edge=T and the poly is not
#            rectangular

  rx <- pts[, 1]
  ry <- pts[, 2]
  nr <- length(rx)
  # no of data points
  pol <- !is.na(poly[1])
  # is polygon specified?
  if (pol) {
    if (sum(inout(pts, poly)) != nr)
      stop("\nThere are observations outside the polygon\n")
  }
  if (!pol) {
    edge  <- F
    # can't do edge corrections if no polygon
    scale <- F
    # can't scale either
    if ((is.na(x[1])) & (is.na(nx))) {
      grid   <- T
      xrange <- (max(rx) - min(rx) + 4 * h)
      xmin   <- min(rx) - 2 * h
      nx     <- max(20, ceiling(xrange/(h/2)))
      yrange <- (max(ry) - min(ry) + 4 * h)
      ymin   <- min(ry) - 2 * h
      ny     <- max(20, ceiling(yrange/(h/2)))
      x      <- ((1:nx) - 1/2)/nx * xrange + xmin
      y      <- ((1:ny) - 1/2)/ny * yrange + ymin
    }
  }
  if ((pol) & (is.na(x[1])) & (is.na(nx))) {
    edge   <- T
    scale  <- T
    xmin   <- min(poly[, 1])
    xmax   <- max(poly[, 1])
    ymin   <- min(poly[, 2])
    ymax   <- max(poly[, 2])
    xrange <- xmax - xmin
    yrange <- ymax - ymin
    nx     <- max(20, ceiling(xrange/(h/2)))
    ny     <- max(20, ceiling(yrange/(h/2)))
    x      <- ((1:nx) - 1/2)/nx * xrange + xmin
    y      <- ((1:ny) - 1/2)/ny * yrange + ymin
  }
  if (grid == T) {
    if (is.na(x[1])) {
      xmin   <- min(poly[, 1])
      xmax   <- max(poly[, 1])
      ymin   <- min(poly[, 2])
      ymax   <- max(poly[, 2])
      xrange <- xmax - xmin
      yrange <- ymax - ymin
      x      <- ((1:nx) - 1/2)/nx * xrange + xmin
      y      <- ((1:ny) - 1/2)/ny * yrange + ymin
    }
    if (is.na(nx)) {
      nx <- length(x)
      ny <- length(y)
    }
    ans        <- list(0, 0, matrix(nrow = nx, ncol = ny), 0)
    names(ans) <- c("x", "y", "z", "scale")
    ans$x      <- x
    ans$y      <- y
    ans$scale  <- 1
    if (pol & (h == Inf)) {
      ans$z  <- matrix(1/areapl(poly), nrow = nx, ncol = ny)
      xyvec  <- cbind(rep(x, ny), rep(y, rep(nx, ny)))
      lpmat1 <- matrix(inout(xyvec, poly), nrow = nx, ncol = ny, byrow = F)
      ans$z[!lpmat1] <- NA
    } else {
      if (edge == T) {
        edgexy <- keredgecor(h, poly, x, y, kernel, grid, innerpoly, rings, npt)
      }
      zmat <- matrix(0, nrow = nx, ncol = ny)
      storage.mode(zmat) <- "single"
      if (kernel == "normal") {
        result <- .Fortran("kdesr2", h = as.single(h),
                                    rx = as.single(rx),
                                    ry = as.single(ry),
                                    nr = as.integer(nr),
                                     x = as.single(x),
                                    nx = as.integer(nx),
                                     y = as.single(y),
                                    ny = as.integer(ny),
                                  zmat = zmat,
					PACKAGE="SpatialEpiR" )
      }
      if (kernel == "quartic") {
        result <- .Fortran("kdesr5", h = as.single(h),
                                    rx = as.single(rx),
                                    ry = as.single(ry),
                                    nr = as.integer(nr),
                                     x = as.single(x),
                                    nx = as.integer(nx),
                                     y = as.single(y),
                                    ny = as.integer(ny),
                                  zmat = zmat,
					PACKAGE="SpatialEpiR" )
      }
      fhat <- result$zmat
      if (edge == T) {
        fhat <- fhat/edgexy
      }
      if (scale == F) {
        ans$z     <- fhat
        ans$scale <- NULL
      } else {
        scal      <- mean(fhat, na.rm = T) * areapl(poly)
        ans$z     <- fhat/scal
        ans$scale <- scal
      }
      if (pol & (edge == F)) {
        xyvec          <- cbind(rep(x, ny), rep(y, rep(nx, ny)))
        lpmat1         <- matrix(inout(xyvec, poly), nrow = nx, ncol = ny, byrow = F)
        ans$z[!lpmat1] <- NA
      }
    }
  }
  if (grid == F) {
    nx <- length(x)
    if (!(nx == length(y)))
      stop("\n The vectors x and y are of different lengths\n"
                        )
    ans <- list(0, 0, 0, 0)
    names(ans) <- c("x", "y", "z", "scale")
    ans$x      <- x
    ans$y      <- y
    ans$scale  <- 1
    if (pol & (h == Inf)) {
      ans$z         <- rep(1/areapl(poly), nx)
      lpin1         <- inout(cbind(x, y), poly)
      ans$z[!lpin1] <- NA
    } else {
      if (edge == T) {
        edgexy <- keredgecor(h, poly, x, y, kernel, grid, innerpoly, rings, npt)
      }
      if (kernel == "normal") {
        result <- .Fortran("kdesr3", h = as.single(h),
                                    rx = as.single(rx),
                                    ry = as.single(ry),
                                    nr = as.integer(nr),
                                     x = as.single(x),
                                     y = as.single(y),
                                    nx = as.integer(nx),
					PACKAGE="SpatialEpiR" )
      }
      if (kernel == "quartic") {
        result <- .Fortran("kdesr6", h = as.single(h),
                                    rx = as.single(rx),
                                    ry = as.single(ry),
                                    nr = as.integer(nr),
                                     x = as.single(x),
                                     y = as.single(y),
                                    nx = as.integer(nx),
					PACKAGE="SpatialEpiR" )
      }
      fhat <- result$x
      if (edge == T) {
        fhat <- fhat/edgexy
      }
      ans$z <- fhat
      if (pol & (edge == F)) {
        lpin1         <- inout(cbind(x, y), poly)
        ans$z[!lpin1] <- NA
      }
    }
  }
  ans
}
