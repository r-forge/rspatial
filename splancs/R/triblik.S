triblik_function(ccflag,vars=NULL,alphas=NULL,betas=NULL
,rho,which=1:length(alphas),covars=NULL,thetas=NULL)
{

	vars_cbind(vars)  # make sure its a matrix
	nalphas_length(alphas)
	nbetas_length(betas)
	if(nalphas!=nbetas){
		stop("alphas and betas must be same length")
	}
	else
	{
		ndpars_nalphas
	}
	npt_length(ccflag)
	if(is.null(vars)){
		ndvars_0
		if(is.null(covars))stop("No variates found!!")
	}
	else
	{
		ndvars_dim(vars)[2]
		if(dim(vars)[1] != npt)stop('Number of variates inconsistent with number of cases/controls')
		if(ndvars < ndpars)stop('More source parameters than variables!')
		if(length(which) != ndvars) stop(' The "which" parameter is not the same length as the number of source parameters')
		wsu_sort(unique(which))
		if(length(wsu) != ndpars)stop('Not enough distinct  values in "which"')
		if(!any(wsu == 1:ndpars))stop('Invalid values in "which"')
	}
	if(is.null(covars) | is.null(thetas)){
		ncovars_0
	} else {
		covars_as.matrix(covars)
		ncovars_dim(covars)[2]
		if(ncovars != length(thetas))stop('Number of parameters inconsistent with covariate array')
		if(dim(covars)[1] != npt)stop('Number of covariates inconsistent with number of cases/controls')
	}

	allvars_cbind(vars,covars)
	nallpars_ndvars*2+ncovars + 1
	
        storage.mode(allvars)_"double"
	
	pars_c(alphas,betas,thetas,rho)

	l_.Fortran('trblik',
		as.integer(ccflag),
		(allvars),
		as.integer(npt),
		as.integer(nallpars),
		as.integer(ndvars),
		as.integer(which),
		as.integer(ndpars),
		as.double(pars),
		dlogl=as.double(1.00))
	l$dlogl
}
	


# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
