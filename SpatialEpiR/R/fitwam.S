# Last modified: 10-8-00

fitwam <- function(formula, g1, g2, z, w, fhat, phat, yvec, pts, poly,
                   hvals, hopt0 = NA, ngrid = 2000) {

# Julia Kelsall
# Sara Morris   (1995)
# Fits a weighted additive model for the specified adjusted dependent variable, z and
# the weights, w following the scheme of Kelsall&Diggle(1998). This function is
# called 10 times by the function fitloggam to fit a logistic generalised additive
# model. The estimated beta and h values are printed along the way such that
# convergence can be assessed.
# formula  the formula of the linear fit
# g1       vector of reals; the linear (fitted) function
# g2       vector of reals; the smooth (fitted) function
# z        vector of reals; adjusted dependent variable
# w        vector of reals; weights from the generalised bit
# fhat     g1+g2; the (fitted) linear predictor of the model
# phat     a vector of estimated probabilities
# yvec     vector of responses
# pts      a point dataset holding the spatial locations of the cases and controls
# poly     a polygon containing the points
# hvals    a vector of length 5, 10, 15 or 20 with possible good values
#          for h, the bandwidth parameter.
#          eg exp(seq(log(100),log(4000),length = 15))
# hopt0    single real value for the kernel regression to use as bandwidth parameter.
#          In the first iteration it should be left as NA and then defined as
#          the previous value in the subsequent calls.
# ngrid    number of points in the grid. Usually only used as non-default value at the
#          last iteration to ensure a finer answer for the final plot.

  # FITTING A WEIGHTED ADDITIVE MODEL:
  cat("(i)", "\n")
  tempform     <- yvar ~ dummy
  formula[[2]] <- tempform[[2]]
  cat("fitting ")
  print(formula)
  cat("\n")
  yvar <- z - g2
  temp <- lm(formula, weights = w)
  g1   <- fitted(temp)
  beta <- temp$coeff
  cat("beta is chosen to be ", beta, "\n")
  yvar  <- z - g1
  hopt1 <- hch2d(pts, hvals, yvar, w)
  cat("the chosen bandwith is ", hopt1, "\n")
  smooth <- kerreg2d(pts, hopt1, yvar, w)
  g2     <- smooth$vals - mean(smooth$vals)
  cat("(ii)", "\n")
  yvar <- z - g2
  temp <- lm(formula, weights = w)
  g1   <- fitted(temp)
  beta <- temp$coeff
  cat("beta is chosen to be ", beta, "\n")
  yvar <- z - g1
  if ((hopt1 == hopt0) & (!is.na(hopt1 == hopt0))) {
    hopt2 <- hopt1
    cat("h is kept fixed", "\n")
  } else {
    hopt2 <- hch2d(pts, hvals, yvar, w)
    cat("the chosen bandwith is ", hopt2, "\n")
  }
  smooth <- kerreg2d(pts, hopt2, yvar, w)
  g2     <- smooth$vals - mean(smooth$vals)
  cat("(iii)", "\n")
  yvar <- z - g2
  temp <- lm(formula, weights = w)
  g1   <- fitted(temp)
  beta <- temp$coeff
  cat("beta is chosen to be ", beta, "\n")
  yvar <- z - g1
  if (hopt2 == hopt1) {
    hopt3 <- hopt2
    cat("h is kept fixed", "\n")
  } else {
    hopt3 <- hch2d(pts, hvals, yvar, w)
    cat("the chosen bandwith is ", hopt3, "\n")
  }
  smooth <- kerreg2d(pts, hopt3, yvar, w)
  g2     <- smooth$vals - mean(smooth$vals)
  cat("(iv)", "\n")
  yvar <- z - g2
  temp <- lm(formula, weights = w)
  g1   <- fitted(temp)
  beta <- temp$coeff
  cat("beta is chosen to be ", beta, "\n")
  yvar <- z - g1
  if (hopt3 == hopt2) {
    hopt4 <- hopt3
    cat("h is kept fixed", "\n")
  } else {
    hopt4 <- hch2d(pts, hvals, yvar, w)
    cat("the chosen bandwith is ", hopt4, "\n")
  }
  smooth <- kerreg2d(pts, hopt4, yvar, w)
  g2     <- smooth$vals - mean(smooth$vals)
  cat("(v)", "\n")
  yvar <- z - g2
  temp <- lm(formula, weights = w)
  g1   <- fitted(temp)
  beta <- temp$coeff
  cat("beta is chosen to be ", beta, "\n")
  yvar <- z - g1
  if (hopt4 == hopt3) {
    hopt5 <- hopt4
    cat("h is kept fixed", "\n")
  } else {
    hopt5 <- hch2d(pts, hvals, yvar, w)
    cat("the chosen bandwith is ", hopt5, "\n")
  }
  smooth <- kerreg2d(pts, hopt5, yvar, w)
  g2     <- smooth$vals - mean(smooth$vals)
  cat("(vi)", "\n")
  gsmooth <- kerreg2d(pts, hopt5, yvar, w, poly = poly, grid = T, ngrid=ngrid)
  fhat    <- g1 + g2
  phat    <- exp(fhat)/(1 + exp(fhat))
  w       <- phat * (1 - phat)
  z       <- fhat + (yvec - phat)/w

  ans     <- list(g1 = g1, g2 = g2, zupdate = z, wupdate = w, fupdate = fhat,
                  pupdate = phat, beta = beta, hlast = hopt5,
                  g2est = list(x = gsmooth$x, y = gsmooth$y, z = gsmooth$z - mean(gsmooth$z,
                  na.rm= T)))
  ans
}
