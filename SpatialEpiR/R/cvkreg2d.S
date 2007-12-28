# Last modified: 10-8-00

cvkreg2d <- function(pts, h, y, w = rep(1, length(y))) {

# Julia Kelsall and Sara Morris
# Evaluates a weighted version of a least squares cross-validation criterion
# for a two-dimensional kernel regression with the bandwidth given in h. The
# criterion is described in more detail as CV5 in Kelsall&Diggle(1998).
# pts    a point dataset
# h      a bandwidth parameter
# y      a vector of values to be smoothed. With binary data it should
#        be 0's and 1's
# w      a vector of weights. The default gives the same weight to all observations

  n  <- length(y)
  x1 <- pts[, 1]
  x2 <- pts[, 2]
  result <- .Fortran("cvker2d", as.single(h),
                                as.single(x1),
                                as.single(x2),
                                as.single(y),
                                as.single(w),
                                as.integer(n),
                           cv = as.single(0))
  ans <- result$cv
  ans
}
