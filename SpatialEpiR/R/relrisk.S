# Last modified: 10-8-00

relrisk <- function(pts1, pts2, poly, h1, h2 = h1, grid = T, ngrid = 500,
                    points = NA, kernel = "normal") {

# Julia Kelsall (1995)
# Calculates the log2 of the ratio of two spatial kernel density estimates
# - this is equivalent to kernel binary regression on the point labels as
# described in Kelsall&Diggle(1998). It is default - and recommended - to
# use the same bandwidth parameter in both numerator and denominator.
# pts1    a point dataset (numerator)
# pts2    a point dataset (denominator)
# poly    a polygon containing all the data points
# h1      a bandwidth parameter to be used with pts1
# h2      a bandwidth parameter to be used with pts2
# grid    logical value. If true the estimate is evaluated on a grid, if false
#         it is evaluated in the points given in points
# ngrid   approximate number of grid points required. Used to construct grid
# points  a point dataset. If grid=F the estimate is evaluated in these points
# kernel  choice of kernel (either "normal" or "quartic")

  if (!(grid) & is.na(points[1])) stop("You need to specify some points")
  if (grid) {
    xrange   <- range(poly[, 1])
    yrange   <- range(poly[, 2])
    xmin     <- xrange[1]
    xmax     <- xrange[2]
    ymin     <- yrange[1]
    ymax     <- yrange[2]
    xlength  <- diff(xrange)
    ylength  <- diff(yrange)
    actngrid <- (ngrid * xlength * ylength)/(areapl(poly))
    nx       <- ceiling(sqrt((actngrid * xlength)/ylength))
    ny       <- ceiling(sqrt((actngrid * ylength)/xlength))
    x        <- seq(xmin + xlength/(2 * nx), xmax - xlength/(2 * nx), length = nx)
    y        <- seq(ymin + ylength/(2 * ny), ymax - ylength/(2 * ny), length = ny)

    kde1     <- kdespat(pts1, h1, poly, kernel = kernel, grid = T,
                        x = x, y = y, edge = F, scale = F)
    kde2     <- kdespat(pts2, h2, poly, kernel = kernel, grid = T,
                        x = x, y = y, edge = F, scale = F)

    ans      <- list(x = x, y = y, z = logb(kde1$z/kde2$z, base = 2))
  } else {
    kde1 <- kdespat(pts1, h1, poly, kernel = kernel, grid = F,
                    x = points[, 1], y = points[, 2], edge = F, scale = F)
    kde2 <- kdespat(pts2, h2, poly, kernel = kernel, grid = F,
                    x = points[, 1], y = points[, 2], edge = F, scale = F)
    ans  <- list(z=(logb(kde1$z, base = 2) - logb(kde2$z, base = 2)))
  }
  ans
}
