# Last modified: Wed 9-8-00

calcvarbeta <- function(pts, poly, cc, h, matched, nsim, covmat=NULL, sztup=NA,
                        edge=T, scale=F, outermax=50, innermax=100, tolbeta=1e-5,
                        tolg=1e-1, rings=10, denspts=10*rings, randomseed=-3547547) {

  # This function estimates the variances of the linear parameters in the GAM
  # for a spatial case-control study (matched or unmatched) as described in
  # (Kelsall & Diggle 1998) and (Jarner et al ???). A Monte Carlo method is
  # used, relabelling the cases and the controls under the hypothesis that
  # the true surface is the actual estimated surface (g=g-hat), re-estimate
  # the surface and the linear parameters for these new datasets and finally
  # calculate the variance on these beta-estimates. As comparison the mean of
  # the variances drawn from the Fisher Information matrix for each
  # re-estimated surface is also returned.
  #
  # pts       the original point-dataset
  # poly      the polygon containing the points
  # cc        a vector of 0 and 1's -- 1 if it corresponds to a case, 0 if to a control
  # h         the bandwidth parameter used to estimate the 'true' surface
  # matched   boolean -- T if the data is matched, F if not
  # nsim      the number of re-estimations to be performed
  # covmat    a matrix containing the covariates (column-wise) - not including a constant term!
  # sztup     the tuple size -- if the study is matched
  # edge      boolean -- if T edgecorrections are performed, if F they are not
  # scale     boolean -- if T all the covariates are scaled to have mean 0 and std 1.
  #           This is advised if any of the covariates take on 'large' values
  # ... see the help documentation

  cat("\nNOTE: this function (calcvarbeta) can easily take hours to run!!\n\n");

  # Creating the variables needed to call the C function mcmc:
  N          <- length(cc)

  succind    <- rep(0,nsim)
  x          <- pts[,1]
  y          <- pts[,2]

  if (is.null(covmat)) {
    nocov    <- 0
    if (matched) nobeta <- 0
    else nobeta <- 1
  } else {
    nocov    <- dim(covmat)[2]
    if (matched) nobeta <- nocov
    else nobeta <- nocov + 1
  }

  if (nobeta<1)
    stop("It only makes sence to run this function if there is any covariates!!\n")
  else {
    bhatvarvec    <- rep(0,nobeta)
    meanfishervec <- rep(0,nobeta)
  }
  if (matched) {
    if (is.na(sztup))
      stop("The size of the tuples must be specified in a matched analysis\n")
    if (sztup < 2)
      stop("Each tuple must contain at least two individuals in a matched case-control study\n")

    notup    <- as.integer(N/sztup)

    if ((notup*sztup) != N) stop("The tuple size is wrongly specified\n")
    if ((sum(cc)) != notup) stop("The number of cases must equal the number of tuples\n")
    for (i in 1:notup) {
      if (cc[(i-1)*sztup + 1] != 1) stop("The dataset is not properly ordered\n");
      for (j in 1:(sztup-1))
        if (cc[(i-1)*sztup +1 + j] != 0) stop("The dataset is not properly ordered\n");
    }
  } else {
    notup    <- N
    sztup    <- 1
  }

  nocases    <- sum(cc)
  Imatch     <- (matched)*1

  # Creating covvec from covmat:
  if (scale) {
    if (nocov>0) {
      covvec <- ((covmat[,1] - mean(covmat[,1]))/sqrt(var(covmat[,1]))[1])  # Here scaling is done!!
      if (nocov>1)
        for (i in 2:nocov) {
          temp <- ((covmat[,i] - mean(covmat[,i]))/sqrt(var(covmat[,i]))[1])
          covvec <- rbind(covvec,temp)
        }
    } else covvec <- 1
  } else {
    if (nocov>0) {
      covvec <- covmat[,1]
      if (nocov>1)
        for (i in 2:nocov) {
          temp <- covmat[,i]
          covvec <- rbind(covvec,temp)
        }
    } else covvec <- 1
  }

  Iedge <- (edge)*1
  if (edge) {
    edgevec <- as.vector(keredgecor(h, poly, x, y,rings=rings,denspts=denspts))
  } else {
    edgevec <- 1
  }

  outbetamcmc <- .C("betamcmc",
                         as.integer(nsim),
                   Isucc=as.integer(succind),
                 bhatvar=as.numeric(bhatvarvec),
                  fisher=as.numeric(meanfishervec),
                         as.integer(cc),
                         as.numeric(covvec),
                         as.numeric(x),
                         as.numeric(y),
                         as.integer(N),
                         as.integer(nocov),
                         as.integer(notup),
                         as.integer(sztup),
                         as.integer(nocases),
                         as.integer(Imatch),
                         as.numeric(h),
                         as.integer(Iedge),
                         as.numeric(edgevec),
                         as.integer(outermax),
                         as.integer(innermax),
                         as.numeric(tolbeta),
                         as.numeric(tolg),
                         as.integer(randomseed) )

  truensim <- sum(outbetamcmc$Isucc)
  cat("\nNOTE: in total",truensim,"of the",nsim,"surfaces converged\n")

  result <- list(truensim=truensim,bhatvar=outbetamcmc$bhatvar,fisher=outbetamcmc$fisher)
  result
}
