# Last modified: 10-8-00

#fitloggam <- function(formula, cc, pts, hvals, poly = unitsq, ngrid=4000) {
fitloggam <- function(formula, cc, pts, hvals, poly, ngrid=4000) {

# Julia Kelsall
# Sara Morris  (1995)
# Fits a logistic generalised additive model following the iterative scheme
# in Kelsall&Diggle(1998). This function calls fitwam 10 times, which in turn fits
# a weighted additive model to the current adjusted dependent variable. In each
# iteration the results are printed to the screen such that convergence can be assessed.
# formula   a formula of the form cc~covars  - the nonlinear/smooth part should not
#           be included here since it is automatically implemented. If there are no
#           covariates write: cc~1.
# cc        a vector of 0's and 1's to represent the cases and controls.
# pts       a point dataset.
# hvals     a vector of length 1, 5, 10, 15 or 20 with possible good values
#           for h, the bandwidth parameter;
#           eg. exp(seq(log(100),log(4000),length = 15))
# poly      a polygon containing the points.
# ngrid     the approximate number of grid points used.

# ADJUSTED DEPENDENT VARIABLE AND WEIGHTS:
# LOGISTIC MODEL

  cat("fitting ", paste("yvar~", formula, sep = ""))
  cat("\n")
  why   <- cc
  ny    <- length(why)
  meany <- mean(why)
  fhatstart <- log(meany/(1 - meany))
  phatstart <- meany
  wstart <- rep(phatstart * (1 - phatstart), ny)
  zstart <- fhatstart + (why - phatstart)/wstart

  # Initialise linear and smooth functions to zeros
  g1start <- rep(0, ny)
  g2start <- rep(0, ny)

  # Call fitwam 10 times. After the first call use the results from the previous iteration
  # as the starting value for the next. In the 10'th and final call ngrid is set to 4000
  # - until then the default of 2000 is used.
  iter1 <- fitwam(formula = formula, g1 = g1start, g2 = g2start, z = zstart,
                  w = wstart, fhat = fstart, phat = pstart, yvec = cc, pts = pts,
                  poly = poly, hvals = hvals)
  last  <- iter1
  iter2 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last  <- iter2
  iter3 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last  <- iter3
  iter4 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last  <- iter4
  iter5 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last  <- iter5
  iter6 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last  <- iter6
  iter7 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last  <- iter7
  iter8 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last  <- iter8
  iter9 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                  w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                  cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast)
  last   <- iter9
  iter10 <- fitwam(formula = formula, last$g1, last$g2, z = last$zupdate,
                   w = last$wupdate, fhat = last$fupdate, phat = last$pupdate,
                   cc, pts, poly = poly, hvals = hvals, hopt0 = last$hlast,
                   ngrid= ngrid)
  iter10
}
