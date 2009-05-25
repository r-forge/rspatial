gvf <- function(var, cols) {
   sumsq <- function(x) sum((x - mean(x))^2)
   sdam <- sumsq(var)
   sdcm <- sum(tapply(var, factor(cols), sumsq))
   res <- 1 - (sdcm/sdam)
   res
}

tai <- function(var, cols) {
   sumabs <- function(x) sum(abs(x - mean(x)))
   x <- sumabs(var)
   y <- sum(tapply(var, factor(cols), sumabs))
   res <- 1 - (y/x)
   res
}

oai <- function(var, cols, area) {
   sumabs1 <- function(x) sum(abs(x[,1] - mean(x[,1]))*x[,2])
   m <- cbind(as.numeric(var), as.numeric(area))
   x <- sumabs1(m)
   y <- sum(by(m, factor(cols), sumabs1))
   res <- 1 - (y/x)
   res
}

jenks.tests <- function(clI, area) {
   if (class(clI) != "classIntervals") stop("Class interval object required")
   cols <- findCols(clI)
   res <- c("# classes"=length(clI$brks)-1, 
     "Goodness of fit"=gvf(clI$var, cols), 
     "Tabular accuracy"=tai(clI$var, cols))
   if (!missing(area)) {
      if (length(area) != length(cols))
         stop("area and classified variable different lengths")
      res <- c(res, "Overview accuracy"=oai(clI$var, cols, area))
   }
   res
}

plot.classIntervals <- function(x, pal, ...) {
   if (class(x) != "classIntervals") stop("Class interval object required")
   if (length(pal) < 2) stop("pal must contain at least two colours")
   pal_out <- colorRampPalette(pal)(length(x$brks)-1)
   plot(ecdf(x$var), ...)
   stbrks <- cbind(x$brks[-length(x$brks)], x$brks[-1])
   abline(v=x$brks, col="grey")
   for (i in 1:nrow(stbrks))
      rect(stbrks[i,1], par("usr")[3], stbrks[i,2], 0, col=pal_out[i],
        border="transparent")
}

classIntervals <- function(var, n, style="quantile", rtimes=3, ..., oldJenks=FALSE) {
  if (is.factor(var)) stop("var is categorical")
  if (!is.numeric(var)) stop("var is not numeric")
  ovar <- var
  if (any(is.na(var))) 
    warning("var has missing values, omitted in finding classes")
  if (any(!is.finite(var))) {
    warning("var has infinite values, omitted in finding classes")
    is.na(var) <- !is.finite(var)
  }
  var <- c(na.omit(var))
  nobs <- length(unique(var))
  if (nobs == 1) stop("single unique value")
  if (missing(n)) n <- nclass.Sturges(var)
  if (n < 2) stop("n less than 2")
  n <- as.integer(n)
  pars <- NULL
  if (n > nobs) {
    warning(paste("n greater than number of different finite values",
      "n reset to number of different finite values", sep="\\n"))
    n <- nobs
  }
  if (n == nobs) {
    warning(paste("n same as number of different finite values",
      "each different finite value is a separate class", sep="\\n"))
    sVar <- sort(unique(var))
    dsVar <- diff(sVar)
    brks <- c(sVar[1]-(mean(dsVar)/2), sVar[1:(length(sVar)-1)]+(dsVar/2),
      sVar[length(sVar)]+(mean(dsVar)/2))
    style="unique"
  } else {
    if (style =="fixed") {
      mc <- match.call(expand.dots=FALSE)
      fixedBreaks <- sort(eval(mc$...$fixedBreaks))
      if (is.null(fixedBreaks)) 
        stop("fixed method requires fixedBreaks argument")
#      if (length(fixedBreaks) != (n+1))
#        stop("mismatch between fixedBreaks and n")
      if (!is.numeric(fixedBreaks)) stop("fixedBreaks must be numeric")
      if (any(diff(fixedBreaks) < 0)) stop("decreasing fixedBreaks found")
      if (min(var) < fixedBreaks[1] || 
        max(var) > fixedBreaks[length(fixedBreaks)])
          warning("variable range greater than fixedBreaks")
      brks <- fixedBreaks
    } else if (style =="sd") {
      svar <- scale(var)
      pars <- c(attr(svar, "scaled:center"), attr(svar, "scaled:scale"))
      names(pars) <- c("center", "scale")
      sbrks <- pretty(x=svar, n=n, ...)
      brks <- c((sbrks * pars[2]) + pars[1])
    } else if (style =="equal") {
      brks <- seq(min(var), max(var), length.out=(n+1))
    } else if (style =="pretty") {
      brks <- c(pretty(x=var, n=n, ...))
    } else if (style =="quantile") {
# stats
      brks <- c(quantile(x=var, probs=seq(0,1,1/n), ...))
      names(brks) <- NULL
    } else if (style =="kmeans") {
# stats
      pars <- try(kmeans(x=var, centers=n, ...))
      if (class(pars) == "try-error") {
        warning("jittering in kmeans")
        jvar <- jitter(rep(x=var, times=rtimes))
        pars <- try(kmeans(x=jvar, centers=n, ...))
	if (class(pars) == "try-error") stop("kmeans failed after jittering")
        else {
          cols <- match(pars$cluster, order(c(pars$centers)))
          rbrks <- unlist(tapply(jvar, factor(cols), range))
        }
      } else {
        cols <- match(pars$cluster, order(c(pars$centers)))
        rbrks <- unlist(tapply(var, factor(cols), range))
      }
      names(rbrks) <- NULL
      brks <- .rbrks(rbrks)
    } else if (style =="hclust") {
# stats
      pars <- hclust(dist(x=var, method="euclidean"), ...)
      rcluster <- cutree(tree=pars, k=n)
      rcenters <- unlist(tapply(var, factor(rcluster), mean))
      cols <- match(rcluster, order(c(rcenters)))
      rbrks <- unlist(tapply(var, factor(cols), range))
      names(rbrks) <- NULL
      brks <- .rbrks(rbrks)
    } else if (style =="bclust") {
# e1071, class
      pars <- try(bclust(x=var, centers=n, ...))
      if (class(pars) == "try-error") {
        warning("jittering in bclust")
        jvar <- jitter(rep(x=var, times=rtimes))
        pars <- try(bclust(x=jvar, centers=n, ...))
	if (class(pars) == "try-error") stop("bclust failed after jittering")
        else {
          cols <- match(pars$cluster, order(c(pars$centers)))
          rbrks <- unlist(tapply(jvar, factor(cols), range))
        }
      } else {
        cols <- match(pars$cluster, order(c(pars$centers)))
        rbrks <- unlist(tapply(var, factor(cols), range))
      }
      names(rbrks) <- NULL
      brks <- .rbrks(rbrks)
    } else if (style =="fisher") {
      pars <- fish(x=var, k=n)
      brks <- pars[n,1]
      for (i in n:1) brks <- c(brks, (pars[i,2]+pars[(i-1),1])/2)
      brks <- c(brks, pars[1,2])
      colnames(pars) <- c("min", "max", "class mean", "class sd")
    } else if (style == "jenks") { # Jenks Optimisation Method
           d <- sort(var)
           k <- n
           #work<-matrix(0,k,length(d))
           mat1 <- matrix(1, length(d), k)
           mat2 <- matrix(0, length(d), k)
           mat2[2:length(d),1:k] <- .Machine$double.xmax #R's max double value?
           v<-0

           for(l in 2:length(d)){
             s1=s2=w=0
             for(m in 1:l){
               i3 <- l - m + 1
               val <- d[i3]
               s2 <- s2 + val * val
               s1 <- s1 + val
               w<-w+1
               v <- s2 - (s1 * s1) / w
               i4 <- trunc(i3 - 1)

               if(i4 !=0){
                 for(j in 2:k){
                   if(mat2[l,j] >= (v + mat2[i4, j - 1])){
                     mat1[l,j] <- i3
                     mat2[l,j] <- v + mat2[i4, j - 1]
                   }
                 }
               }
             }
             mat1[l,1] <- 1
             mat2[l,1] <- v
           }

           kclass<-1:k
           kclass[k] <- length(d)
           k <- length(d)
           last<-length(d)
           for(j in length(kclass):1){
             id <- trunc(mat1[k,j]) - 1
             kclass[j - 1] <- id
             k <- id #lower
             last <- k -1 #upper
           }
           if (oldJenks) {
               brks<-d[c(1, kclass)]
           } else {
# correction contributed by Richard Dunlap 090512
               tempbrks  <- d[c(1, kclass)]
               tempbrks2 <- d[c(1, kclass) + 1]
               brks <- c(tempbrks[1], ((tempbrks + tempbrks2)/2)[2:n], 
                   tempbrks[n+1])
           }
      } else stop(paste(style, "unknown"))
  }
  if (is.null(brks)) stop("Null breaks")
  res <- list(var=ovar, brks=brks)
  attr(res, "style") <- style
  attr(res, "parameters") <- pars
  attr(res, "nobs") <- nobs
  attr(res, "call") <- match.call()
  class(res) <- "classIntervals"
  res
}

.rbrks <- function(rbrks) {
  nb <- length(rbrks)
  if (nb < 2) stop("single break")
  brks <- c(rbrks[1], rbrks[nb])
  if (nb > 2) {
    if (nb == 3) brks <- append(brks, rbrks[2], 1)
    else { 
      ins <- NULL
      for (i in as.integer(seq(2,(nb-2),2))) {
        ins <- c(ins, ((rbrks[i]+rbrks[i+1])/2))
      }
      brks <- append(brks, ins, 1)
    }
  }
  brks
}

findColours <- function(clI, pal, under="under", over="over", between="-",
  digits = getOption("digits"), cutlabels=FALSE) {
  if (class(clI) != "classIntervals") stop("Class interval object required")
  if (is.null(clI$brks)) stop("Null breaks")
  if (length(pal) < 2) stop("pal must contain at least two colours")
  cols <- findCols(clI)
  palette <- colorRampPalette(pal)(length(clI$brks)-1)
  res <- palette[cols]
  attr(res, "palette") <- palette
  tab <- tableClassIntervals(cols=cols, brks=clI$brks, under=under, over=over,
    between=between, digits=digits, cutlabels=cutlabels)
  attr(res, "table") <- tab
  res
}

findCols <- function(clI)  {
  if (class(clI) != "classIntervals") stop("Class interval object required")
  if (is.null(clI$brks)) stop("Null breaks")
  cols <- findInterval(clI$var, clI$brks, all.inside=TRUE)
  cols
}

tableClassIntervals <- function(cols, brks, under="under", over="over",
   between="-", digits = getOption("digits"), cutlabels=FALSE) {
   x <- format(brks, digits=digits, trim=TRUE)
   lx <- length(x)
   nres <- character(lx - 1)
   sep <- " "
   if (cutlabels) {
      sep <- ""
      between=", "
   }
   if (cutlabels) nres[1] <- paste("[", x[1], between, x[2], "]", sep=sep)
   else nres[1] <- paste(under, x[2], sep=sep)
   for (i in 2:(lx - 2)) {
      if (cutlabels) nres[i] <- paste("(", x[i], between, x[i + 1], "]",
         sep=sep)
      else nres[i] <- paste(x[i], between, x[i + 1], sep=sep)
   }
   if (cutlabels) nres[lx - 1] <- paste("(", x[lx - 1], between, x[lx], "]",
     sep=sep)
   else nres[lx - 1] <- paste(over, x[lx - 1], sep=sep)
   tab <- table(factor(cols, levels=1:(lx - 1)))
   names(tab) <- nres
   tab
}

print.classIntervals <- function(x, digits = getOption("digits"), ..., under="under", over="over", between="-", cutlabels=TRUE) {
   if (class(x) != "classIntervals") stop("Class interval object required")
   cat("style: ", attr(x, "style"), "\n", sep="")
   nP <- nPartitions(x)
   if (is.finite(nP)) cat("  one of ", prettyNum(nP, big.mark = ","),
      " possible partitions of this variable into ", length(x$brks)-1,
      " classes\n", sep="")
   cols <- findCols(x)
   tab <- tableClassIntervals(cols=cols, brks=x$brks, digits=digits,
      cutlabels=cutlabels)
   print(tab, digits=digits, ...)
   invisible(tab)
}

nPartitions <- function(x) {
  n <- attr(x, "nobs")
  k <- length(x$brks)-1
  (factorial(n - 1))/(factorial(n - k) * factorial(k - 1))
}

getBclustClassIntervals <- function(clI, k) {
  if (class(clI) != "classIntervals") stop("Class interval object required")
  if (missing(k)) k <- length(clI$brks)-1
  if (class(attr(clI, "parameters")) != "bclust") 
    stop("Class interval object not made with style=\"bclust\"")

  ovar <- clI$var
  var <- clI$var
  if (any(!is.finite(var))) is.na(var) <- !is.finite(var)
  var <- c(na.omit(var))

  obj <- attr(clI, "parameters")
  cols <- match(clusters.bclust(obj, k=k), order(centers.bclust(obj, k=k)))
  rbrks <- unlist(tapply(var, factor(cols), range))
  names(rbrks) <- NULL
  brks <- .rbrks(rbrks)

  res <- list(var=ovar, brks=brks)
  attr(res, "style") <- attr(clI, "style")
  attr(res, "parameters") <- attr(clI, "parameters")
  attr(res, "nobs") <- attr(clI, "nobs")
  attr(res, "call") <- attr(clI, "call")
  attr(res, "modified") <- c(attr(clI, "modified"), k)
  class(res) <- "classIntervals"
  res

}

getHclustClassIntervals <- function(clI, k) {
  if (class(clI) != "classIntervals") stop("Class interval object required")
  if (missing(k)) k <- length(clI$brks)-1
  if (class(attr(clI, "parameters")) != "hclust") 
    stop("Class interval object not made with style=\"hclust\"")

  ovar <- clI$var
  var <- clI$var
  if (any(!is.finite(var))) is.na(var) <- !is.finite(var)
  var <- c(na.omit(var))

  obj <- attr(clI, "parameters")
  rcluster <- cutree(tree=obj, k=k)
  rcenters <- unlist(tapply(var, factor(rcluster), mean))
  cols <- match(rcluster, order(c(rcenters)))
  rbrks <- unlist(tapply(var, factor(cols), range))
  names(rbrks) <- NULL
  brks <- .rbrks(rbrks)

  res <- list(var=ovar, brks=brks)
  attr(res, "style") <- attr(clI, "style")
  attr(res, "parameters") <- attr(clI, "parameters")
  attr(res, "nobs") <- attr(clI, "nobs")
  attr(res, "call") <- attr(clI, "call")
  attr(res, "modified") <- c(attr(clI, "modified"), k)
  class(res) <- "classIntervals"
  res

}

fish <- function(x, k) {
   x <- sort(x)
   m <- length(x)
   k <- as.integer(k)
   work <- double(m*k)
   iwork <- integer(m*k)
   res <- double(k*4)
   out <- .Fortran("fish", as.integer(m), as.double(x), as.integer(k),
      as.integer(m), as.double(work), as.integer(m), as.integer(iwork),
      as.double(res), PACKAGE="classInt")[[8]]
   out <- matrix(out, k, 4)
   out
}
