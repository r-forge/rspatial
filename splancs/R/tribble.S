tribble_function(ccflag,vars=NULL,alphas=NULL,betas=NULL,rho
  ,which=1:length(alphas),covars=NULL,thetas=NULL,steps=NULL
  ,reqmin=0.001,icount=50,hessian=NULL)
{
        library.dynam('splancs','tribble.o')
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
# scale distances
		disscale_apply(vars,2,max)
		vars_vars/matrix(disscale,ncol=ndvars,nrow=npt,byrow=T)
	}
	if(is.null(covars) | is.null(thetas)){
		ncovars_0
	} else {
		covars_as.matrix(covars)
		ncovars_dim(covars)[2]
		if(ncovars != length(thetas))stop('Number of parameters inconsistent with covariate array')
		if(dim(covars)[1] != npt)stop('Number of covariates inconsistent with number of cases/controls')
# scale covariates
		covscale_abs(apply(covars,2,max))
		covars_covars/matrix(covscale,ncol=ncovars,nrow=npt,byrow=T)
		
	}

	allvars_cbind(vars,covars)

	nallpars_ndvars*2+ncovars + 1
	
        print(nallpars)
        storage.mode(allvars)_"double"
	
	pstart_c(alphas,betas,thetas,rho)
# initial steps - .5 for a,b,t, .1 for rho
	if(is.null(steps))steps_c(rep(0.5,length=ndvars*2+ncovars),.1)

	l_.Fortran('tribble',
		as.integer(ccflag),
		(allvars),
		as.integer(npt),
		as.integer(ndvars),
		as.integer(ndpars),
		as.integer(ncovars),
		as.integer(which),
		as.double(pstart),
		parfin=as.double(pstart),
		as.double(steps),
		as.double(reqmin),
		icode=as.integer(icount),
		kcode=as.integer(1),
		dlogl=as.double(1.00))
	alphas_betas_thetas_NULL
	if(ndpars!=0){
		alphas_l$parfin[1:ndpars]
		betas_(l$parfin[(ndpars+1):(ndpars*2)])/disscale
	}
	if(l$icode < 0)stop(paste("Error in minimisation algorithm code ",icode))
	rho_l$parfin[length(l$parfin)]
	if(ncovars != 0){
	  thetas_l$parfin[(1+ndpars*2):(ncovars+ndpars*2)]
	  thetas_thetas/covscale
	}

	ncase_sum(ccflag)
        ncont_sum(1-ccflag)
        p_ncase/(ncase+ncont)
        null.logl_log(p)*ncase+log(1-p)*ncont

res_list(alphas=alphas,betas=betas,thetas=thetas,rho=rho,logl=l$dlogl,
null.logl=null.logl,kcode=l$kcode,
call=match.call())
	class(res)_"ribfit"

	if(!is.null(hessian)){

	  hess1_hessian.ribfit(res,ccflag=ccflag,vars=vars,covars=covars,which=which)
	  hess2_hessian2.ribfit(res,ccflag=ccflag,vars=vars,covars=covars,which=which)
	  res$hessian.1_hess1
	  res$hessian.2_hess2
	}

	res
}
	


# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
