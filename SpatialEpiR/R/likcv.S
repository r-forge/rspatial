# Last modified 10-8-00

likcv <- function(pts1, pts2, h, kernel = "normal") {

# Julia Kelsall 1995
# Modified by Sara Morris in 1996
# Calculates the likelihood cross-validation criterion for a given bandwidth h,
# as defined in Kelsall and Diggle (1998) for a binary regression problem.
# We automatically divide by the value of the L-CV obtained by using an
# infinite smoothing parameter, such that all values are positive and
# such that values below 1 indicate a non-constant spatial surface.
# pts1    a point dataset (the cases)
# pts2    a point dataset (the controls)
# h       a bandwidth parameter
# kernel  choice of kernel (either "normal" or "quartic")

  if (!(kernel == "normal") & !(kernel == "quartic")) {
    stop("The kernel requested is undefined")
  }
  data1x <- pts1[, 1]
  data1y <- pts1[, 2]
  n1     <- length(data1x)
  data2x <- pts2[, 1]
  data2y <- pts2[, 2]
  n2     <- length(data2x)
  fdata1 <- kdespat(pts1, h, kernel = kernel, grid = FALSE, x = data1x, y = data1y)$z
  fdata2 <- kdespat(pts1, h, kernel = kernel, grid = FALSE, x = data2x, y = data2y)$z
  gdata1 <- kdespat(pts2, h, kernel = kernel, grid = FALSE, x = data1x, y = data1y)$z
  gdata2 <- kdespat(pts2, h, kernel = kernel, grid = FALSE, x = data2x, y = data2y)$z
  if (kernel == "normal") {
    hbit <- 1/(2 * pi * h^2)
  }
  if (kernel == "quartic") {
    hbit <- 3/(8 * pi * h^2)
  }
  fdata1r <- (n1 * fdata1 - hbit)/(n1 - 1)
  gdata2r <- (n2 * gdata2 - hbit)/(n2 - 1)
  bit1    <- ((n1 - 1) * fdata1r)/(n2 * gdata1 + (n1 - 1) * fdata1r)
  ans1    <-  - sum(log(abs(bit1)))
  bit2    <- ((n2 - 1) * gdata2r)/(n1 * fdata2 + (n2 - 1) * gdata2r)
  ans2    <-  - sum(log(abs(bit2)))
  ans     <- exp((ans1 + ans2)/(n1 + n2))
  pp      <- n1/(n1 + n2)
  infval  <- (n1 + n2 - 1) * (n1 - 1)^( - pp) * (n2 - 1)^(pp - 1)

  ans/infval
}
