rlabel <- function(...){
	arglist <- list(...)
	nptsets <- length(arglist)
	ntotpts <- 0
	allpts <- NULL
	newperm <- NULL
	for(ia in 1:nptsets){
		nptsia <- npts(arglist[[ia]])
		ntotpts <- ntotpts+nptsia
		allpts <- rbind(allpts,arglist[[ia]])
		newperm <- c(newperm,rep(ia,times=nptsia))
	}
	newperm <- sample(newperm)
	outlist <- list()
	for(ia in 1:nptsets){
		outlist[[ia]] <- allpts[newperm==ia,]
	}
	outlist
}

