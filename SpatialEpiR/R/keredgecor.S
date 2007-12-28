# The Splus function fitsmacc calls the C function smaccest which estimates
# the risk surface for a matched resp. unmatched case-control dataset.
# Note that the resulting s-vector is forced to have mean 0 (or something very close to it)

# Last modified: Fri 7-8-00

keredgecor <- function(h, poly, x, y, kernel = "normal", rings = 10, denspts = 10 * rings) {

# Mikala Jarner (2000). Modification of Julia Kelsall's function kdeedge. This function uses a new
# external C-file (instead of Julia's Fortran code) to perform the point-in-polygon test needed for
# calculating the edge correction.

# Calculates edge-corrections for a kernel density estimate on a specified polygon.

# h          a bandwidth parameter
# x          This should be a vector of x-coordinates which in combination with y constitutes
#            the points in which the edge-corrections are calculated
# y          like x, but for the y-coordinates
# poly       a polygon containing the points
# kernel     a choice of kernel (either "normal" or "quartic")
# rings      the larger this number is the more accurate are the edge-corrections - the default
#            of 10 should be god enough in most cases. This option is only used if the poly is
#            not rectangular
# denspts    the larger this number is the more accurate are the edge-corrections - the default
#            should be adequate. Again this option is only used if the poly is not rectangular

  if (kernel=="normal") Ikernel=1
  else if (kernel=="quartic") Ikernel=2
  else stop("The function is only defined for kernel='normal' and kernel='quartic'\n")

  rect <- F
  if (length(poly[,1] == 4)) {
    if ((poly[1,1] == poly[2,1]) & (poly[2,2] == poly[3,2]) &
      (poly[3,1] == poly[4,1]) & (poly[4,2] == poly[1,2])) {
      rect <- T
    }
    if ((poly[1,2] == poly[2,2]) & (poly[2,1] == poly[3,1]) &
      (poly[3,2] == poly[4,2]) & (poly[4,1] == poly[1,1])) {
      rect <- T
    }
  }
  if ((rect == T) && (Ikernel==1)) {   # If rectangular polygon with normal kernel
    xmin   <- min(poly[, 1])          # the analytical solution is used.
    xmax   <- max(poly[, 1])
    ymin   <- min(poly[, 2])
    ymax   <- max(poly[, 2])
    edgex  <- pnorm(xmax, x, h) - pnorm(xmin, x, h)
    edgey  <- pnorm(ymax, y, h) - pnorm(ymin, y, h)
    answer <- edgex * edgey
  } else {                           # Otherwise an approximation is used as described by Julia Kelsall

    polyx <- cbind(poly[,1],poly[1,1])
    polyy <- cbind(poly[,2],poly[1,2])  # The first point is copied to the end of the list
    npoly <- length(polyx)

    npoints <- length(x)
    edgevec <- rep(1,npoints)

    outedge <- .C("keredgecor", as.numeric(h),
                                as.numeric(polyx),
                                as.numeric(polyy),
                                as.integer(npoly),
                                as.numeric(x),
                                as.numeric(y),
                                as.integer(npoints),
                                as.integer(Ikernel),
                                as.integer(rings),
                                as.integer(denspts),
                      edgevec = as.numeric(edgevec),
				PACKAGE="SpatialEpiR" )

    answer <- outedge$edgevec
  }
  answer
}
