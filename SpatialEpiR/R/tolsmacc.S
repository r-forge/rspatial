# Last modified: wed 9-8-00

tolsmacc <- function(pts, poly, cc, h, matched, nsim, surfacels, meansurface, tzero,
                     covmat = NULL, sztup = NA, edge = T, scale = F, outermax = 50,
                     innermax = 100, tolbeta = 1e-05, tolg = 0.1, rings = 10,
                     denspts = 10 * rings, randomseed = -3547547) {

# This function calculates 95% tolerance contours of the risk-surface estimated
# by the function 'fitsmacc'. A Monte Carlo method is used, relabelling the cases
# and controls under the null hypothesis of no spatial variation in risk (g=0) and
# then re-estimating the surface for the new datasets. In each point the proportion
# of surfaces with a value smaller than that of the original surface is calculated
# and it is the 0.025 and 0.975 contours of this probability-surface that are
# finally used.
#
# pts         the original points dataset
# poly        the polygon containing the points
# cc          a vector of 0 and 1's -- 1 if it corresponds to a case, 0 if to a control
# h           the bandwidth parameter used to estimate the 'true' surface
# matched     boolean -- T if the data is matched, F if not
# nsim        the number of re-estimations to be performed
# surfacels   the fitted surface (x,y,z); after call to fitsmacc $surface contains this
# meansurface the mean value of the estimated surface in the original points; again a
#             variable with this name and information is given after a call to fitsmacc
# tzero       value of the test statistic for the original surface
# covmat      a matrix containing the covariates (column-wise) - not including a constant term!
# sztup       the tuple size -- if the study is matched
# edge        boolean -- if T edgecorrections are performed, if F they are not
# scale       boolean -- if T all the covariates are scaled to have mean 0 and std 1;
#             scaling is advised if any of the covariates take on 'large' values
# ... se the help documentation

  cat("\nNOTE: this function (tolsmacc) can easily take hours to run!!\n\n")

  # Creating the variables needed to call the C function mcmc:
  N          <- length(cc)
  tvec       <- rep(0, nsim)
  succind    <- rep(0, nsim)
  xgrid      <- surfacels$x
  ygrid      <- surfacels$y
  nx         <- length(xgrid)
  ny         <- length(ygrid)
  probvec    <- rep(0, nx * ny)
  surfacevec <- as.vector(surfacels$z)
  x          <- pts[, 1]
  y          <- pts[, 2]
  if (is.null(covmat)) {
    nocov <- 0
    if (matched)
      nobeta <- 0
    else nobeta <- 1
  } else {
    nocov <- dim(covmat)[2]
    if (matched)
      nobeta <- nocov
    else nobeta <- nocov + 1
  }
  if (matched) {
    if (is.na(sztup))
      stop("The size of the tuples must be specified in a matched analysis\n")
    if (sztup < 2)
      stop("Each tuple must contain at least two individuals in a matched case-control study\n")
    notup <- as.integer(N/sztup)
    if ((notup * sztup) != N)
      stop("The tuple size is wrongly specified\n")
    if ((sum(cc)) != notup)
      stop("The number of cases must equal the number of tuples\n")
    for (i in 1:notup) {
      if (cc[(i - 1) * sztup + 1] != 1)
        stop("The dataset is not properly ordered\n")
      for (j in 1:(sztup - 1))
        if (cc[(i - 1) * sztup + 1 + j] != 0) stop("The dataset is not properly ordered\n")
    }
  } else {
    notup <- N
    sztup <- 1
  }
  nocases <- sum(cc)
  Imatch  <- (matched) * 1
  # Creating covvec from covmat:
  if (scale) {
    if (nocov > 0) {
      covvec <- ((covmat[, 1] - mean(covmat[, 1]))/sqrt(var(covmat[, 1]))[1])
      # Here scaling is done!!
      if (nocov > 1) for(i in 2:nocov) {
        temp   <- ((covmat[, i] - mean(covmat[, i]))/sqrt(var(covmat[, i]))[1])
        covvec <- rbind(covvec, temp)
      }
    } else covvec <- 1
  } else {
    if (nocov > 0) {
      covvec <- covmat[, 1]
      if (nocov > 1)
        for (i in 2:nocov) {
          temp   <- covmat[, i]
          covvec <- rbind(covvec, temp)
        }
    } else covvec <- 1
  }
  Iedge <- (edge) * 1
  if (edge) {
    edgevec <- as.vector(keredgecor(h, poly, x, y, rings = rings, denspts = denspts))
  } else {
    edgevec <- 1
  }
  # Creating the logical vector Ipoly --- 1 if the corresponding point is inside the polygon
  # and 0 if it is outside:
  xyvec1 <- rep(xgrid, ny)
  xyvec2 <- rep(ygrid, each = nx)
  xyvec  <- cbind(xyvec1, xyvec2)
  Ipoly  <- inout(xyvec, poly) * 1

  # converting the NA's in surfacevec to zero's:
  surfacevec[(Ipoly < 1)] = 0

  outmcmc <- .C("mcmc", as.integer(nsim),
                 prob = as.double(probvec),
                 test = as.double(tvec),
                Isucc = as.integer(succind),
                        as.double(xgrid),
                        as.double(ygrid),
                        as.integer(nx),
                        as.integer(ny),
                        as.integer(Ipoly),
                        as.double(surfacevec),
                        as.integer(cc),
                        as.double(covvec),
                        as.double(x),
                        as.double(y),
                        as.integer(N),
                        as.integer(nocov),
                        as.integer(notup),
                        as.integer(sztup),
                        as.integer(nocases),
                        as.integer(Imatch),
                        as.double(h),
                        as.integer(Iedge),
                        as.double(edgevec),
                        as.integer(outermax),
                        as.integer(innermax),
                        as.double(tolbeta),
                        as.double(tolg),
                        as.integer(randomseed))

  truensim <- sum(outmcmc$Isucc)
  cat("\nNOTE: in total", truensim, "of the", nsim,"surfaces converged\n")
  probvec  <- outmcmc$prob
  probvec[(Ipoly < 1)] = NA
  probmat  <- matrix(probvec, nrow = nx, ncol = ny, byrow = F)
  ranking  <- sum(outmcmc$test[(outmcmc$Isucc == 1)] > tzero)
  # number of t's larger than tzero
  pvalue   <- (ranking + 1)/(truensim + 1)
  if (truensim != nsim) {
    lowerlim  <- (ranking + 1)/(nsim + 1)
    upperlim  <- (ranking + (nsim - truensim) + 1)/(nsim + 1)
    pinterval <- c(lowerlim, upperlim)
  } else {
    pinterval <- pvalue
  }
  result <- list(probmat = probmat, pval = pvalue, pinterval = pinterval,
                 truensim = truensim)

  result
}
