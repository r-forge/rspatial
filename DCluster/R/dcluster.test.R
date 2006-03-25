#
#Funstions to provide an easier interface to the library
#
#

#d= data
#model = "permut", "multinom", "poisson", "negbin"

#Returns some of the parameters needed by boot.
dotest<-function(stat, d, model, R, ...)
{
	#Type of bootstrap
	if(model=="permut")
	{
		sim<-"ordinary"
		statistic<-paste(stat, ".boot", sep="")

		p<-list(sim=sim, statistic=statistic, ran.gen=NULL)
	}
	else
	{
		sim<-"parametric"
		statistic<-paste(stat, ".pboot", sep="")
		ran.gen<-paste(model, ".sim", sep="")

		p<-list(sim=sim, statistic=statistic, ran.gen=ran.gen)
	}


	#Do the test!!
	if(is.null(p$ran.gen))
		result<-boot(d, statistic=get(p$statistic), R=R, ...)
	else
	{
		result<-boot(d, statistic=get(p$statistic), 
		  sim=p$sim, ran.gen=get(p$ran.gen), R=R, ...)
		result$sim<-p$sim
		result$ran.gen<-p$ran.gen
	}

	result$statistic<-p$statistic

	class(result)<-"dcluster"
	return(result)
}

achisq.test<-function(d, model, R, ...)
{
	ifelse(length(list(...))>0,
		return(dotest("achisq", d, model, R, ...)),
		return(dotest("achisq", d, model, R))
	)
}


pottwhitt.test<-function(d, model, R, ...)
{
	ifelse(length(list(...))>0,
		return(dotest("pottwhitt", d, model, R, ...)),
		return(dotest("pottwhitt", d, model, R))
	)
}


moranI.test<-function(d, model, R, ...)
{
	ifelse(length(list(...))>0,
		return(dotest("moranI", d, model, R, ...)),
		return(dotest("moranI", d, model, R))
	)
}

gearyc.test<-function(d, model, R, ...)
{
	ifelse(length(list(...))>0,
		return(dotest("gearyc", d, model, R, ...)),
		return(dotest("gearyc", d, model, R))
	)
}


tango.test<-function(d, model, R, ...)
{
	ifelse(length(list(...))>0,
		return(dotest("tango", d, model, R, ...)),
		return(dotest("tango", d, model, R))
	)
}

whittermore.test<-function(d, model, R, ...)
{
	ifelse(length(list(...))>0,
		return(dotest("whittermore", d, model, R, ...)),
		return(dotest("whittermore", d, model, R))
	)
}


#
#This function produces a pretty output of the boot object created by
#varios tests
#


#This function can be used to display results in a boot object
dcluster.test<-function(b)
{
	a<-b
	p<-as.character(b$call)

	a$statistic<-p[3]
	a$ran.gen<-p[6]

	class(a)<-"dcluster"
	summary(a)
}


summary.dcluster<-function(object, ...)
{

b<-object

cl<-attr(b, "class")#Get class
if("dcluster"==cl)
{

	#Parameters used in the call to boot(...)
	#p<-as.character(b$call)

	#Test computed
	test<-(strsplit(b$statistic, ".", fixed=TRUE))[[1]][1]

	#Title
	title<-switch(test,
	"achisq"="Chi-square test for overdispersion",
	"pottwhitt"="Potthoff-Whittinghill's test of overdispersion",
	"moranI"="Moran's I test of spatial autocorrelation",
	"gearyc"="Geary's c test of spatial autocorrelation",
	"whittermore"="Whittermore's test of global clustering",
	"tango"="Tango's test of global clustering"
	)

	#Sampling model
	m<-(strsplit(b$ran.gen, ".", fixed=TRUE))[[1]][1]
	if("parametric"==b$sim)
	{
		model<-switch(m, 
			"multinom"="Multinomial",
			"poisson"="Poisson",
			"negbin"="Negative Binomial"
			)
	}
	else
	{
		model<-"permutation"
	}
	

	pvalue<-(1+sum(as.numeric(b$t0)<as.numeric(b$t)))/(b$R+1)

	cat(title, '\n\n')
	cat("\tType of boots.:", b$sim,'\n')
	cat("\tModel used when sampling:", model, '\n')
	cat("\tNumber of simulations:", b$R, '\n')
	cat("\tStatistic: ", b$t0, '\n')
	cat("\tp-value : ", pvalue, '\n')
}
else
{
if("data.frame"==cl)
{

	cat('Scan test for the detection of clusters of disease\n\n')


	d<-dim(b)
	if(d[1]>0)
	{
		cat('\tNumber of significant cluster centres:', d[1], '\n')

		i<-which.min(b$pvalue)

	#Check if the KN's statistic has been used...
	kn<-round(b$statistic[1])!=b$statistic[1]#If the statistic is NOT an integer...

	if(!kn)#Summarise GAM results
	{

		i<-which.min(b$pvalue)
			cat('\tCluster with the lowest p-value: (',b$x[i] ,', ', b$y[i] ,
			'),  size:',b$size[i], ', pvalue:',b$pvalue[i], '\n') 


	}
	else#Kulldorff's statistic output
	{
		i<-which.max(b$statistic)	


		cat('\tMost likely cluster: (',b$x[i] ,', ', b$y[i] ,
                        '), likelihood ratio: ', b$statistic[i] ,', size:',b$size[i], ', pvalue:',b$pvalue[i], '\n')
	

	}

	}

}
}

}


print.dcluster<-function(x, ...){summary(x)}


plot.dcluster<-function(x, ...)
{
	xl<-range(c(x$t0, x$t))

	hist(x$t, main="Histogram of the simulated values", xlim=xl,
	  xlab="Statistic", ... )
	abline(v=x$t0, lty=2)
}
