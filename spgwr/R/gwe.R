# Copyright 2001-2004 Roger Bivand and Danlin Yu
# 

gw.dists <- function(dp, pt, lonlat=FALSE) {
	n <- nrow(dp)
	dists <- numeric(n)
	res <- .C("gw_dists", as.double(dp[,1]), as.double(dp[,2]),
		as.double(pt[1]), as.double(pt[2]), as.integer(n),
		as.double(dists), as.integer(lonlat), PACKAGE="spgwr")[[6]]
	res
}

gw.adapt <- function(dp, fp, quant, lonlat=FALSE) {
	n1 <- nrow(dp)
	n2 <- nrow(fp)
	dists <- numeric(n1)
	bw <- numeric(n2)
	if (quant > 1) {
		factor <- quant
		quant <- 1
		res <- .C("gw_adapt", as.double(dp[,1]), as.double(dp[,2]),
			as.double(fp[,1]), as.double(fp[,2]), as.integer(n1),
			as.integer(n2), as.double(bw), as.double(quant),
			as.double(dists), as.integer(lonlat), 
			PACKAGE="spgwr")[[7]]
		res <- res*factor
	} else {
		n.ideal <- n1*quant
		n.lower <- floor(n.ideal)
		n.higher <- n.lower+1
		q1 <- n.lower/n1
		q2 <- n.higher/n1
		res1 <- .C("gw_adapt", as.double(dp[,1]), as.double(dp[,2]),
			as.double(fp[,1]), as.double(fp[,2]), as.integer(n1),
			as.integer(n2), as.double(bw), as.double(q1),
			as.double(dists), as.integer(lonlat), 
			PACKAGE="spgwr")[[7]]
		res2 <- .C("gw_adapt", as.double(dp[,1]), as.double(dp[,2]),
			as.double(fp[,1]), as.double(fp[,2]), as.integer(n1),
			as.integer(n2), as.double(bw), as.double(q2),
			as.double(dists), as.integer(lonlat), 
			PACKAGE="spgwr")[[7]]

		res <- (n.ideal - n.lower)*res2 + (n.higher - n.ideal)*res1
	}
	res
}


gw.cov <- function(x, dp, fp, adapt=NULL, bw, gweight=gwr.bisquare, cor=TRUE,
		var.term=FALSE, lonlat=FALSE) {
	if (any(is.na(x))) stop("x contains NAs")
	x <- as.matrix(x)
	nc <- ncol(x)
	if (is.null(colnames(x))) colnames(x) <- paste("V", 1:nc, sep="")
	cn <- colnames(x)
	n1 <- nrow(dp)
	if (n1 != nrow(x)) stop ("Differing row numbers between x and dp")

	# prepare bandwidths for data points
	if (is.null(adapt)) {
		if (!missing(bw)) bw0 <- rep(bw, n1)
		else stop("Bandwidth must be given for non-adaptive weights")
	}
	else bw0 <- gw.adapt(dp=dp, fp=dp, quant=adapt)
	dm <- numeric(nc)
	rss <- numeric(nc)
	trhat <- 0
	for (i in 1:n1) { # establish residuals for data points and 
			# calculate hat matrix trace
		wts <- gweight(gw.dists(dp, dp[i,], lonlat=lonlat), bw0[i])
		for (j in 1:nc) {
			dm[j] <- weighted.mean(x[,j], wts)
			rss[j] <- rss[j] + (x[i,j] - dm[j])^2
		}
		trhat <- trhat + wts[i]/sum(wts)
	}
	dm <- sqrt(rss/(n1 - trhat))
	# global adjusted residual standard error

	if (missing(fp)) {
		fp.given <- FALSE
		fp <- dp
		colnames(fp) <- colnames(dp)
	} else fp.given <- TRUE
	gridded <- gridded(fp)
	if (gridded) fp <- coordinates(fp)

	# prepare bandwidths for fitting/estimation points
	n2 <- nrow(fp)
	if (is.null(adapt)) {
		if (!missing(bw)) bw <- rep(bw, n2)
		else stop("Bandwidth must be given for non-adaptive weights")
	}
	else bw <- gw.adapt(dp=dp, fp=fp, quant=adapt)
	
	ut <- ((nc^2 -nc)/2)
	res <- matrix(NA, nrow=n2, ncol=((2*nc)+(ifelse(cor, 2*ut, ut))))
	rnm <- paste("mean", cn, sep=".")
	rnm <- c(rnm, paste("sd", cn, sep="."))
	if (nc > 1) {
		corn <- outer(cn, cn, paste, sep=",")
		rnm <- c(rnm, 
			paste("cov(", corn[upper.tri(corn)], ")", sep=""))
		if (cor) rnm <- c(rnm, 
			paste("cor(", corn[upper.tri(corn)], ")", sep=""))
	}
	
	colnames(res) <- rnm
	swts <- numeric(n2)
	swts2 <- numeric(n2)

	for (i in 1:n2) {
		wts <- gweight(gw.dists(dp, fp[i,], lonlat=lonlat), bw[i])
		swts[i] <- sum(wts)
		swts2[i] <- sum((wts/swts[i])^2)
		res1 <- cov.wt(as.matrix(x), wts, cor=cor)
		res[i, 1:nc] <- res1$center
		if (var.term) {
			cov <- res1$cov * sqrt(1 - swts2[i])
		} else {
			cov <- res1$cov
		}
		sd <- sqrt(diag(cov))
		res[i, (nc+1):(2*nc)] <- sd
		if (nc > 1) {
			res[i, ((2*nc)+1):((2*nc)+ut)] <- 
				res1$cov[upper.tri(res1$cov)]
			if (cor) {
			        sdinv <- diag(1/sd, nrow(cov))
        			corr <- sdinv %*% cov %*% sdinv
				res[i, ((2*nc)+ut+1):((2*nc)+2*ut)] <- 
					corr[upper.tri(corr)]
			}
		}
	}
	class(res) <- c("gw.cov", "matrix")
	attr(res, "bw") <- bw
	attr(res, "swts") <- swts
	attr(res, "sdswts2") <- swts2
	attr(res, "grid") <- grid
	attr(res, "fp.given") <- fp.given
	attr(res, "g.se") <- dm
	res
}



display.gw.cov <- function(cov, colno, breaks, col, ...) {
	if (!inherits(cov, "gw.cov")) stop("not at gw.cov object")
	if (colno < 1 || colno > ncol(cov)) stop("column number invalid")
	grid <- attr(cov, "grid")
	xseq <- attr(grid, "xseq")
	yseq <- attr(grid, "yseq")
	res <- grid$res
	mat <- matrix(cov[,colno], res[1], res[2])
	if (missing(breaks)) 
		breaks <- quantile(cov[,colno], seq(0, 1, 1/10), na.rm=TRUE)
	if (missing(col)) col <- heat.colors(length(breaks)-1)
	image(xseq, yseq, mat, main=colnames(cov)[colno], 
		breaks=breaks, col=col, ...)
	invisible(list(x=xseq, y=yseq, z=mat))
}

sem.gw.cov <- function(cov, x) {
	if (!inherits(cov, "gw.cov")) stop("not a gw.cov object")
	if (any(is.na(x))) stop("x contains NAs")
	x <- as.matrix(x)
	nc <- ncol(x)
	if (is.null(colnames(x))) colnames(x) <- paste("V", 1:nc, sep="")
	cn <- colnames(x)
	gxbar <- apply(x, 2, mean)
	means <- grep("mean", colnames(cov))
	if (nc != length(means)) stop("mismatch in x and cov")
	sds <- grep("sd", colnames(cov))
	res <- matrix(NA, nrow=nrow(cov), ncol=nc*4)
	res[,1:(nc*2)] <- cov[,1:(nc*2)]
	rnm <- colnames(cov)[1:(nc*2)]
	for (i in means) res[,((nc*2)+i)] <- 
		attr(cov, "g.se")[i] * sqrt(attr(cov, "sdswts2"))
	rnm <- c(rnm, paste("sem", cn, sep="."))
	for (i in means) 
		res[,((nc*3)+i)] <- (gxbar[i] - cov[,i]) / res[,((nc*2)+i)]
	rnm <- c(rnm, paste("diff", cn, sep="."))
	colnames(res) <- rnm
	class(res) <- c("sem.gw.cov", class(cov))
	attr(res, "bw") <- attr(cov, "bw")
	attr(res, "swts") <- attr(cov, "swts")
	attr(res, "sdswts2") <- attr(cov, "sdswts2")
	attr(res, "grid") <- attr(cov, "grid")
	attr(res, "fp.given") <- attr(cov, "fp.given")
	attr(res, "g.se") <- attr(cov, "g.se")
	res
}



