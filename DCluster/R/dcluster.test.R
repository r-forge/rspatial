#
#This function produces a pretty output of the boot object created by
#varios tests
#

dcluster.test<-function(b)
{

cl<-attr(b, "class")#Get class
if("boot"==cl)
{

	#Parameters used in the call to boot(...)
	p<-as.character(b$call)

	#Test computed
	test<-(strsplit(p[3], ".", fixed=TRUE))[[1]][1]

	#Title
	title<-switch(test,
	"achisq"="Chi-square test for overdispertion",
	"pottwhitt"="Potthoff-Whittinghill's test of overdispertion",
	"moranI"="Moran's I test of spatial autocorrelation",
	"gearyc"="Geary's c test of spatial autocorrelation",
	"whittermore"="Whittermore's test of global clustering",
	"tango"="Tango's test of global clustering"
	)

	#Sampling model
	m<-(strsplit(p[6], ".", fixed=TRUE))[[1]][1]
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
