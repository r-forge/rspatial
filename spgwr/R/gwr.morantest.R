gwr.morantest <- function(x, listw, zero.policy = FALSE) {
	if(class(x) != "gwr") stop(paste(deparse(substitute(x)),
		"not a gwr object"))
	if (!inherits(listw, "listw"))
		stop(paste(deparse(substitute(listw)), "is not a listw object"))
#	require(ctest)
	n <- ncol(x$lhat)
	if (n != length(listw$neighbours)) stop("objects of different length")
	if (listw$style != "W") warning(deparse(substitute(listw)),
		"not row standardised")
	W <- listw2mat(listw2U(listw))
	N <- diag(n) - x$lhat
	e.gwr <- N %*% x$lm$y
	sh.test <- shapiro.test(e.gwr)
	sh.test$data.name <- "GWR residuals"
	I0.gwr <- c((t(e.gwr) %*% W %*% e.gwr) / (t(e.gwr) %*% e.gwr))
	A <- t(N) %*% (W - I0.gwr*diag(n)) %*% N
	EQ.gwr <- sum(diag(A))
	tr2 <- sum(diag(A %*% A))
	tr3 <- sum(diag(A %*% A %*% A))
	varQ.gwr <- 2*tr2
	EQ.EQ3.gwr <- 8*tr3
	h.gwr <- tr2^3/tr3^2
	chi2.gwr <- 0
	p.gwr <- 0
	if (EQ.EQ3.gwr > 0) {
		chi2.gwr <- h.gwr - ((sqrt(2*h.gwr)*EQ.gwr)/(sqrt(varQ.gwr)))
		p.gwr <- 1 - pchisq(chi2.gwr, h.gwr)
		}
	else if (EQ.EQ3.gwr < 0) {
		chi2.gwr <- (h.gwr +
			((sqrt(2*h.gwr)*EQ.gwr)/(sqrt(varQ.gwr))))
		p.gwr <- pchisq(chi2.gwr, h.gwr)
		}
	GWRtest <- list(estimate=c(I = I0.gwr),
		statistic=c(statistic = chi2.gwr), parameter=c(df = h.gwr),
		p.value=p.gwr, data.name="GWR residuals",
		method="Leung et al. 2000 three moment approximation for Moran's I")
	class(GWRtest) <- "htest"
	m <- ncol(x$lm$x)
	Z <- matrix(0, m, m)
	Z[upper.tri(Z, diag=TRUE)] <- x$lm$qr$qr[upper.tri(x$lm$qr$qr,
		diag=TRUE)]
	Z[lower.tri(Z)] <- x$lm$qr$qr[upper.tri(x$lm$qr$qr)]
	inv.Z <- chol2inv(Z)
	N <- diag(n) - x$lm$x %*% inv.Z %*% t(x$lm$x)
	e.ols <- N %*% x$lm$y
	I0.ols <- c((t(e.ols) %*% W %*% e.ols) / (t(e.ols) %*% e.ols))
	trN.ols <- sum(diag(N))
	A <- (W - I0.ols*diag(n)) %*% N
	EQ.ols <- sum(diag(A))
	varQ.ols <- 2*sum(diag(A %*% A))
	EQ.EQ3.ols <- 8*sum(diag(A %*% A %*% A))
	h.ols <- (8*varQ.ols^3) / (EQ.EQ3.ols^2)
	chi2.ols <- 0
	p.ols <- 0
	if (EQ.EQ3.ols > 0) {
		chi2.ols <- h.ols - ((sqrt(2*h.ols)*EQ.ols)/(sqrt(varQ.ols)))
		p.ols <- 1 - pchisq(chi2.ols, h.ols)
	}
	else if (EQ.EQ3.ols < 0) {
		chi2.ols <- (h.ols +
			((sqrt(2*h.ols)*EQ.ols)/(sqrt(varQ.ols))))
		p.ols <- pchisq(chi2.ols, h.ols)
	}
	OLStest <- list(estimate=c(I = I0.ols),
		statistic=c(statistic = chi2.ols), parameter=c(df = h.ols),
		p.value=p.ols, data.name="OLS residuals",
		method="Leung et al. 2000 three moment approximation for Moran's I")
	class(OLStest) <- "htest"
#	cat("Test of GWR model residual spatial autocorrelation\nCall:\n")
#	print(x$this.call)
#	print(sh.test)
	print(GWRtest)
#	print(OLStest)
	invisible(list(GWR=GWRtest, OLS=OLStest, GWRresids=e.gwr))
}
