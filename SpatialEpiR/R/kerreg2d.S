# Last modified: 10-8-00

kerreg2d <- function(pts, h, y, w = rep(1, length(y)), poly = NA, x = pts,
                     grid = F, ngrid= 1000) {

# Julia Kelsall
# Sara Morris
# Calculates a two-dimensional weighted kernel regression of the y values at
# the locations given by pts.
# pts    a point dataset
# h      a bandwidth parameter
# y      a vector of values to be smoothed
# w      a vector of weights. Default gives the same weight to all observations
# poly   a polygon containing the points in pts - only used if grid=T
# x      a point dataset which indicates were the fitted surface should be evaluated.
#        The default is just using the point dataset given by pts.
# grid   logical value. If true a regular grid is constructed within poly and the
#        surface is evaluated on this instead of at the points given by the points in x
# ngrid  approximate number of points to use if grid=T
  if (!grid) {
    n      <- length(y)
    m      <- length(x[, 1])
    yans   <- rep(0.3, m)
    datx1  <- pts[, 1]
    datx2  <- pts[, 2]
    x1     <- x[, 1]
    x2     <- x[, 2]
    result <- .Fortran("ker2d", h = as.single(h),
                            datx1 = as.single(datx1),
                            datx2 = as.single(datx2),
                                y = as.single(y),
                                w = as.single(w),
                                n = as.integer(n),
                               x1 = as.single(x1),
                               x2 = as.single(x2),
                             yans = as.single(yans),
                                m = as.integer(m),
                               df = as.single(0))
    ans <- list(vals = result$yans, df = result$df)
  }
  if (grid) {
    n        <- length(y)
    datx1    <- pts[, 1]
    datx2    <- pts[, 2]
    x1range  <- range(poly[, 1])
    x2range  <- range(poly[, 2])
    x1min    <- x1range[1]
    x1max    <- x1range[2]
    x2min    <- x2range[1]
    x2max    <- x2range[2]
    x1length <- diff(x1range)
    x2length <- diff(x2range)
    actngrid <- (ngrid/(areapl(poly))) * x1length * x2length
    m1       <- ceiling(sqrt((actngrid * x1length)/x2length))
    m2       <- ceiling(sqrt((actngrid * x2length)/x1length))
    zmat     <- matrix(0, m1, m2)
    storage.mode(zmat) <- "single"
    x1       <- seq(x1min + x1length/(2 * m1), x1max - x1length/(2 * m1),length = m1)
    x2       <- seq(x2min + x2length/(2 * m2), x2max - x2length/(2*m2),length=m2)
    xyvec1   <- rep(x1, m2)
    xyvec2   <- rep(x2, rep(m1, m2))
    xyvec    <- cbind(xyvec1, xyvec2)
    lpmat    <- matrix(inout(xyvec, poly), nrow = m1, ncol = m2, byrow = F)
    storage.mode(lpmat) <- "logical"
    result   <- .Fortran("ker2dg", h = as.single(h),
                               datx1 = as.single(datx1),
                               datx2 = as.single(datx2),
                                   y = as.single(y),
                                   w = as.single(w),
                                   n = as.integer(n),
                                  x1 = as.single(x1),
                                  x2 = as.single(x2),
                                zmat = zmat,
                               lpmat = lpmat,
                                  m1 = as.integer(m1),
                                  m2 = as.integer(m2))
    z         <- result$zmat
    z[z == 0] <- NA
    ans       <- list(x = x1, y = x2, z = z)
  }
  ans
}
