# Last modified 10-8-00

minh <- function(pts1, pts2, hvals, kernel = "normal", graph = TRUE) {

# Sara Morris (1996)
# Runs the function likcv on a vector of h values and singles out the one that
# minimises the likelihood cross-validation criterion stated in Kelsall&Diggle(1998)
# (When doing density ratio estimation using the binary regression approach).
# pts1    a point dataset (the cases)
# pts2    a point dataset (the controls)
# hlow    a vector of bandwidth parameters
# kernel  choice of kernel (either "normal" or "quartic")
# graph   if true the L-CV values are plotted against the h values on the current
#         graphics device

  lik.cv <- NULL
  for (i in hvals) {
    lik.cv <- c(lik.cv, likcv(pts1 = pts1, pts2 = pts2, h = i, kernel = kernel))
  }
  if (graph) {
    plot(hvals, lik.cv, type = "b")
    if ((min(lik.cv, na.rm = TRUE) <= 1) & (max(lik.cv, na.rm = TRUE) >= 1)) abline(h = 1, lty = 2)
  }
  hmin   <- hvals[lik.cv == min(lik.cv, na.rm = TRUE)]
  cat("The minimising h value is ", hmin, "\n")
  answer <- list(hvalues = hvals, cv = lik.cv, hopt = hmin)
  answer
}
