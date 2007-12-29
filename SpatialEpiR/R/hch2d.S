# Last modified: 10-8-00

hch2d <- function(pts, hvals, y, w = rep(1, length(y)), quiet = TRUE) {

# Julia Kelsall and Sara Morris
# Runs the function cvkreg2d on a vector of h values and singles out the one that
# minimises the weighted least squares cross-validation criterion for kernel
# regression. For computational reasons the length of hvals should be either 1, 5,
# 10, 15 or 20.
# pts     a point dataset
# hvals   a vector of possible bandwidth parameter values of length 1,5,10,15 or 20.
#         The vector of h values is often chosen to be on a log scale
# y       a vector of values to be smoothed. With binary data it should
#         be 0's and 1's
# w       a vector of weights. Default gives the same weight to all observations
# quiet   logical value. If false a matrix is printed to the screen of each value of
#         h and its corresponding criterion value

  nh <- length(hvals)
  #  cat("The length of hvals is",nh,"\n")
  if ((nh != 1) & (nh != 5) & (nh != 10) & (nh != 15) & (nh != 20))
    stop("The length of hvals must be either 5,10,15 or 20")
  cv    <- rep(NA, nh)
  i     <- 1
  cv[i] <- cvkreg2d(pts, hvals[i], y, w)
  if (!quiet) cat(i, hvals[i], cv[i], "\n")
  if (nh > 1) {
    i     <- 2
    cv[i] <- cvkreg2d(pts, hvals[i], y, w)
    if (!quiet) cat(i, hvals[i], cv[i], "\n")
    i     <- 3
    cv[i] <- cvkreg2d(pts, hvals[i], y, w)
    if(!quiet) cat(i, hvals[i], cv[i], "\n")
    i     <- 4
    cv[i] <- cvkreg2d(pts, hvals[i], y, w)
    if (!quiet) cat(i, hvals[i], cv[i], "\n")
    i     <- 5
    cv[i] <- cvkreg2d(pts, hvals[i], y, w)
    if (!quiet) cat(i, hvals[i], cv[i], "\n")
    if (nh > 5) {
      i     <- 6
      cv[i] <- cvkreg2d(pts, hvals[i], y, w)
      if (!quiet) cat(i, hvals[i], cv[i], "\n")
      i     <- 7
      cv[i] <- cvkreg2d(pts, hvals[i], y, w)
      if (!quiet) cat(i, hvals[i], cv[i], "\n")
      i     <- 8
      cv[i] <- cvkreg2d(pts, hvals[i], y, w)
      if (!quiet) cat(i, hvals[i], cv[i], "\n")
      i     <- 9
      cv[i] <- cvkreg2d(pts, hvals[i], y, w)
      if (!quiet) cat(i, hvals[i], cv[i], "\n")
      i     <- 10
      cv[i] <- cvkreg2d(pts, hvals[i], y, w)
      if (!quiet) cat(i, hvals[i], cv[i], "\n")
      if (nh > 10) {
        i     <- 11
        cv[i] <- cvkreg2d(pts, hvals[i], y, w)
        if(!quiet) cat(i, hvals[i], cv[i], "\n")
        i     <- 12
        cv[i] <- cvkreg2d(pts, hvals[i], y, w)
        if(!quiet) cat(i, hvals[i], cv[i], "\n")
        i     <- 13
        cv[i] <- cvkreg2d(pts, hvals[i], y, w)
        if(!quiet) cat(i, hvals[i], cv[i], "\n")
        i     <- 14
        cv[i] <- cvkreg2d(pts, hvals[i], y, w)
        if(!quiet) cat(i, hvals[i], cv[i], "\n")
        i     <- 15
        cv[i] <- cvkreg2d(pts, hvals[i], y, w)
        if(!quiet) cat(i, hvals[i], cv[i], "\n")
        if(nh > 15) {
          i     <- 16
          cv[i] <- cvkreg2d(pts, hvals[i], y, w)
          if(!quiet) cat(i, hvals[i], cv[i], "\n")
          i     <- 17
          cv[i] <- cvkreg2d(pts, hvals[i], y, w)
          if(!quiet) cat(i, hvals[i], cv[i], "\n")
          i     <- 18
          cv[i] <- cvkreg2d(pts, hvals[i], y, w)
          if(!quiet) cat(i, hvals[i], cv[i], "\n")
          i     <- 19
          cv[i] <- cvkreg2d(pts, hvals[i], y, w)
          if(!quiet) cat(i, hvals[i], cv[i], "\n")
          i     <- 20
          cv[i] <- cvkreg2d(pts, hvals[i], y, w)
          if(!quiet) cat(i, hvals[i], cv[i], "\n")
        }
      }
    }
  }
  if (any(is.na(cv))) warning("One of CV values is an NA")
  opt <- (1:nh)[cv == min(cv, na.rm = TRUE)]
  ans <- hvals[sort(opt)]
  if  (length(ans) > 1)
    ans <- (max(ans))

  ans
}
