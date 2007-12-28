Edhat <- function(pts1, pts2, poly, s, k) {

# The expectation of K11-hat minus K22-hat for a matched case-control
# dataset is calculated. For details see (Chetwynd, Diggle and Marshall, 2001).

# pts1  a point dataset containing the cases.
# pts2  a point dataset containing the matched controls. The first n rows
#       should contain the first set of controls while the next n rows should
#       contain the second set of controls and so on.
# poly  a polygon containing all the points.
# s     a vector of distances for which the K-functions are evaluated.
# k     the number of events in a tuple, ie. k-1 is the number of matched
#       controls per case.

# The function returns a vector of the same length as s containing the
# expectations.

  ns <- length(s)
  np <- npts(poly)
  xp <- c(poly[, 1], poly[1, 1])
  yp <- c(poly[, 2], poly[1, 2])
  n1 <- npts(pts1)
  n2 <- npts(pts2)
  n  <- n1 + n2
  smax <- max(s)
  x  <- c(pts1[, 1], pts2[, 1])
  y  <- c(pts1[, 2], pts2[, 2])
  Amt <- matrix(0, ncol = ns, nrow = n)
  Bmt <- matrix(0, ncol = ns, nrow = n)
  bgu <- vector(mode = "numeric", length = ns)
  bgv <- vector(mode = "numeric", length = ns)
  bgw <- vector(mode = "numeric", length = ns)
  slist <- .Fortran("edhatk",
        x = as.double(x),
        y = as.double(y),
            as.integer(n),
            as.integer(n1),
            as.integer(n2),
            as.double(xp),
            as.double(yp),
            as.integer(np),
            as.double(s),
            as.integer(ns),
            as.double(Amt),
            as.double(Bmt),
      bgu = as.double(bgu),
      bgv = as.double(bgv),
      bgw = as.double(bgw),
            as.integer(k))

  answer <- slist[[15]]

  answer
}

Vdhat <- function(pts1, pts2, poly, s, k) {
# The variance of K11-hat minus K22-hat for a matched case-control
# dataset with tuplesizes 2 or 3 is calculated. A general expression
# for an arbitrary number of controls per case is stated in
# (Chetwynd, Diggle and Marshall, 2001) but has not been implemented.

# pts1  a point dataset containing the cases.
# pts2  a point dataset containing the matched controls. The first n rows
#       should contain the first set of controls while the next n rows should
#       contain the second set of controls and so on.
# poly  a polygon containing all the points.
# s     a vector of distances for which the K-functions are evaluated.
# k     the number of events in a tuple, ie. k-1 is the number of matched
#       controls per case. Till now only the values 2 and 3 apply.

# The function returns a vector of the same length as s containing
# the variances.

  ns <- length(s)
  np <- npts(poly)
  xp <- c(poly[, 1], poly[1, 1])
  yp <- c(poly[, 2], poly[1, 2])
  n1 <- npts(pts1)
  n  <- k * n1
  smax <- max(s)
  x  <- c(pts1[, 1], pts2[, 1])
  y  <- c(pts1[, 2], pts2[, 2])
  a  <- vector(mode = "numeric", length = ns)
  b  <- vector(mode = "numeric", length = ns)
  e  <- vector(mode = "numeric", length = ns)
  R  <- matrix(0, ncol = ns, nrow = n)
  Z  <- matrix(0, ncol = ns, nrow = n1)

  if (k==2) {
    ulist <- .Fortran("v1",
               as.double(x),
               as.double(y),
               as.integer(n),
               as.integer(n1),
               as.double(xp),
               as.double(yp),
               as.integer(np),
               as.double(s),
               as.integer(ns),
               as.double(R),
               as.double(Z),
               as.double(a),
               as.double(b),
               as.double(e))

    answer <- ulist[[12]]
  } else if (k==3) {
    c  <- vector(mode = "numeric", length = ns)
    d  <- vector(mode = "numeric", length = ns)
    f  <- vector(mode = "numeric", length = ns)
    g  <- vector(mode = "numeric", length = ns)
    h  <- vector(mode = "numeric", length = ns)
    o  <- vector(mode = "numeric", length = ns)
    p  <- vector(mode = "numeric", length = ns)
    q  <- vector(mode = "numeric", length = ns)
    t  <- matrix(0, ncol = ns, nrow = n1)
    U  <- matrix(0, ncol = ns, nrow = n1)

    tlist <- .Fortran("v",
               as.double(x),
               as.double(y),
               as.integer(n),
               as.integer(n1),
               as.double(xp),
               as.double(yp),
               as.integer(np),
               as.double(s),
               as.integer(ns),
               as.double(R),
               as.double(Z),
               as.double(t),
               as.double(U),
               as.double(a),
               as.double(b),
               as.double(c),
               as.double(d),
               as.double(e),
               as.double(f),
               as.double(g),
               as.double(h),
               as.double(o),
               as.double(p),
               as.double(q))

    answer <- tlist[[18]]
  } else stop("This function is only defined for tuplesizes of 2 and 3\n")

  answer
}

Testdhat <- function(pts1, pts2, poly, s, k, nrelab = 99) {
# Calculates the test statistic in (Chetwynd, Diggle and Marshall, 2001) for
# a matched case-control study and performes a Monte Carlo test of 'no overall
# clustering' by doing 99 random relabellings of the data.

# pts1    a point dataset containing the cases.
# pts2    a point dataset containing the matched controls. The first n rows
#         should contain the first set of controls while the next n rows should
#         contain the second set of controls and so on.
# poly    a polygon containing all the points.
# s       a vector of distances for which the K-functions are evaluated.
# k       the number of events in a tuple, ie. k-1 is the number of matched
#         controls per case. Till now only the values 2 and 3 apply.
# nrelab  the number of relabellings performed in the Monte Carlo test. The
#         default is 99. 
  
# The function returns a list with two objects: 'test' contains the value of
# the test statistic for the original data and 'pval' contains the P-value
# of the performed Monte Carlo test.

  cat("\nNOTE: this function (Testdhat) can easily take hours to run!!\n\n");

  e <- Edhat(pts1, pts2, poly, s, k)
  v <- Vdhat(pts1, pts2, poly, s, k)
  if (min(v)<0.0001)
    stop("Some of the s-values are to small - try with some larger ones!\n")

  dhat  <- khat(pts1, poly, s) - khat(pts2, poly, s)
  Dstat <- sum((dhat - e)/sqrt(v))

  npts1  <- npts(pts1)
  allpts <- rbind(pts1, pts2)
  n      <- npts(allpts)

  for(i in 2:(nrelab+1)) {
    indicator <- sample(1:n, npts1)
    newpts1   <- allpts[indicator,  ]
    newpts2   <- allpts[ - indicator,  ]
    newdhat   <- khat(newpts1, poly, s) - khat(newpts2, poly, s)
    e <- Edhat(newpts1, newpts2, poly, s, k)
    v <- Vdhat(newpts1, newpts2, poly, s, k)
    if (min(v)<0.0001)
      stop("Some of the s-values are to small - try with some larger ones!\n")

    D <- sum((newdhat - e)/sqrt(v))
    Dstat <- rbind(Dstat, D)
  }

  pval   <- ((nrelab+1) - rank(Dstat)[1] +1)/(nrelab+1)
  answer <- list(test=Dstat[1], pval=pval)

  answer
}

