gwr.mc <- function(formula, data = list(), coords, bandwidth, gweight=gwr.gauss, nsim) {
	this.call <- match.call()
	mt <- terms(formula, data = data)
	mf <- lm(formula, data, method="model.frame")
	if (missing(coords))
		stop("Observation coordinates have to be given")
	if (missing(bandwidth)) stop("No bandwidth value given")
	if (missing(nsim)) stop("No nsim value given")
	if (bandwidth < 0) stop("Invalid bandwidth")
	xdiff <- diff(range(coords[,1]))
	ydiff <- diff(range(coords[,2]))
	if (bandwidth > min(xdiff,ydiff)) stop("Invalid bandwidth")
	require(mva)
	y <- model.response(mf, "numeric")
	x <- model.matrix(mt, mf)
	n <- NROW(x)
	m <- NCOL(x)
	if (NROW(x) != NROW(coords))
		stop("Input data and coordinates have different dimensions")
	dist2 <- (as.matrix(dist(coords)))^2
	w <- gweight(dist2, bandwidth)
	gwr.res <- array(data=0, dim=c(n, m, nsim+1))
	varnames <- colnames(x)
	nos <- 1:n
	for (sim in 1:nsim) {
		for (i in 1:n) {
			perm <- sample(nos)
			lm.i <- lm.wfit(y=y[perm], x=x[perm,], w=w[i,])
			gwr.res[i,,sim] <- coefficients(lm.i)
		}
	}
	for (i in 1:n) {
		lm.i <- lm.wfit(y=y, x=x, w=w[i,])
		gwr.res[i,,nsim+1] <- coefficients(lm.i)
	}
	rank.mod <- function(x) rank(x)[length(x)]
	rank.res <- matrix(0, ncol=m, nrow=n)
	for (i in 1:n) {
		for (j in 1:m) rank.res[i,j] <- rank.mod(gwr.res[i,j,])
	}
	z <- list(this.call=this.call, nsim=nsim, bandwidth=bandwidth,
		ranks=rank.res)
	invisible(z)

}
