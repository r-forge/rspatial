# The Splus function fitsmacc calls the C function smaccest which estimates
# the risk surface for a matched resp. unmatched case-control dataset.
# Note that the resulting s-vector is forced to have mean 0 (or something very close to it)

# Last modified: Fri 4-8-00

fitsmacc <- function(pts, poly, cc, hvals, matched, covmat = NULL, sztup = NA, edge = T,
        scale = F, ngrid = 4000, outermax = 50, innermax = 100, tolbeta = 1e-05,
        tolg = 0.1, rings = 10, denspts = 10 * rings) {

# This function estimates the parameters and the risk-surface in the GAM described
# in (Kelsall and diggle, 1998) and (Jarner et al., tech report, 2002) for a spatial
# (matched or 
# unmatched) case-control points dataset. An iterative estimation algorithm is
# used applying kernel smoothing for the non-parametric part and maksimum
# likelihood for the linear part.
#
# pts       the points dataset
# poly      the polygon containing the points
# cc        a vector of 0 and 1's -- 1 if it corresponds to a case, 0 if to a control
# hvals     a vector of possible bandwidth parameters from which the 'optimal' is chosen
# matched   boolean -- T if the data is matched, F if not
# covmat    a matrix containing the covariates (column-wise) - not including a constant term!
# sztup     the tuple size -- if the study is matched
# edge      boolean -- if T edgecorrections are performed, if F they are not
# scale     boolean -- if T all the covariates are scaled to have mean 0 and std 1.
#           This is advised if any of the covariates take on 'large' values
# ... see help documentation for details.

# Calculate new variables and check that the information given is consistent:
  N <- length(cc)
  if (is.null(covmat)) nocov <- 0
  else                 nocov <- dim(covmat)[2]
  if (matched) {
    if (is.na(sztup))
      stop("The size of the tuples must be specified in a matched analysis\n")
    if (sztup < 2)
      stop("Each tuple must contain at least two individuals in a matched case-control study\n")
    notup <- as.integer(N/sztup)
    if (nocov > 0) {
      beta    <- rep(0.1, nocov)
      # The initial values of beta is set here
      varbeta <- rep(0, nocov)
    } else {
      beta    <- 0.1
      varbeta <- 0
    }
    if ((notup * sztup) != N)
      stop("The tuple size is wrongly specified\n")
    if ((sum(cc)) != notup)
      stop("The number of cases must equal the number of tuples\n")
    for (i in 1:notup) {
      if (cc[(i - 1) * sztup + 1] != 1)
        stop("The dataset is not properly ordered\n")
      for (j in 1:(sztup - 1))
        if (cc[(i - 1) * sztup + 1 + j] != 0)
          stop("The dataset is not properly ordered\n")
    }
  } else {
    notup   <- N
    sztup   <- 1
    beta    <- rep(0.1, nocov + 1)
    # The initial values of beta is set here
    varbeta <- rep(0, nocov + 1)
  }
  if ((!is.null(covmat)) && (dim(covmat)[1] != N))
    stop("Dimension miss match - length of cc vector must equal the number of rows in covmat\n"
                )
  Imatch <- (matched) * 1
  ptsx   <- pts[, 1]
  ptsy   <- pts[, 2]
  noh    <- length(hvals)
  hopt   <- hvals[1]
  Iedge  <- (edge) * 1
  if (edge) {
    edgevec <- as.vector(keredgecor(hvals[1], poly, ptsx, ptsy,
                                    rings = rings, denspts = denspts))
    if (noh > 1) {
      for(i in 2:noh)
        edgevec <- cbind(edgevec, as.vector(keredgecor(hvals[i], poly, ptsx, ptsy,
                                                       rings = rings, denspts = denspts)))
    }
    edgevec <- as.vector(edgevec)
  } else {
    edgevec <- 1
  }
  if (scale) {
    if (nocov > 0) {
      covvec <- ((covmat[, 1] - mean(covmat[, 1]))/sqrt(var(covmat[, 1]))[1])
      # Here scaling is done!!
      if (nocov > 1) for(i in 2:nocov) {
        temp   <- ((covmat[, i] - mean(covmat[, i]))/sqrt(var(covmat[, i]))[1])
        covvec <- cbind(covvec, temp)
      }
    } else covvec <- 1
  } else {
    if (nocov > 0) {
      covvec <- covmat[, 1]
      if (nocov > 1)
        for(i in 2:nocov) {
          temp   <- covmat[, i]
          covvec <- cbind(covvec, temp)
        }
    } else covvec <- 1
  }
  s  <- ptsx
  w  <- ptsx
  cv <- rep(0, noh)

  outsmacc <- .C("smaccest", as.integer(cc),
                             as.double(covvec),
                             as.double(ptsx),
                             as.double(ptsy),
                             as.integer(N),
                             as.integer(nocov),
                             as.integer(notup),
                             as.integer(sztup),
                             as.integer(Imatch),
                             as.double(hvals),
                             as.integer(noh),
                             as.integer(Iedge),
                             as.double(edgevec),
                        cv = as.double(cv),
                         s = as.double(s),
                      beta = as.double(beta),
                    fisher = as.double(varbeta),
                         w = as.double(w),
                      hopt = as.double(hopt),
                             as.integer(outermax),
                             as.integer(innermax),
                             as.double(tolbeta),
                             as.double(tolg))

  # Unscaling of the estimated beta-values is performed!!
  if (scale) {
    if (matched) {
      if (nocov > 0)
        for (i in 1:nocov)
          beta[i] <- outsmacc$beta[i]/sqrt(var(covmat[, i]))[1]
    } else {
      temp = 0
      if (nocov > 0)
        for (i in 1:nocov) {
          temp = temp + (mean(covmat[, i])/sqrt(var(covmat[, i]))[1]) *
                                           outsmacc$beta[i + 1]
          beta[i + 1] <- outsmacc$beta[i + 1]/sqrt(var(covmat[, i]))[1]
        }
      beta[1] <- outsmacc$beta[1] - temp
    }
  }
  w <- outsmacc$w
  if (edge) {
    edgevecopt <- keredgecor(outsmacc$hopt, poly, ptsx, ptsy,
                             rings = rings, denspts = denspts)
    w <- w/edgevecopt
  }

  surface     <- kerreg2d(pts, outsmacc$hopt, outsmacc$s, w = w, poly = poly,
                          grid = T, ngrid = ngrid)
  ptssurface  <- kerreg2d(pts, outsmacc$hopt, outsmacc$s, w = w,
                          poly = poly, x = pts, grid = F)
  meansurface <- mean(ptssurface$vals)
  test        <- mean((ptssurface$vals - meansurface) * (ptssurface$vals - meansurface))
  result      <- list(s = outsmacc$s, w = outsmacc$w, surface = surface,
                      meansurface = meansurface, test = test, beta = outsmacc$beta,
                      fisher = outsmacc$fisher, cv = outsmacc$cv, hopt = outsmacc$hopt)
  # consists of (x,y,z) (z=NA outside poly!)
  result
}
