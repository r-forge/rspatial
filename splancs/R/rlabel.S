rlabel <- function(...){
	arglist_list(...)
	nptsets_length(arglist)
	ntotpts_0
	allpts_NULL
	newperm_NULL
	for(ia in 1:nptsets){
		nptsia_npts(arglist[[ia]])
		ntotpts_ntotpts+nptsia
		allpts_rbind(allpts,arglist[[ia]])
		newperm_c(newperm,rep(ia,times=nptsia))
	}
	newperm_sample(newperm)
	outlist_list()
	for(ia in 1:nptsets){
		outlist[[ia]]_allpts[newperm==ia,]
	}
	outlist
}

