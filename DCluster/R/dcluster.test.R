#
#This function produces a pretty output of the boot object created by
#varios tests
#

dcluster.test<-function(b)
{

cl<-attr(b, "class")#Get class
if(grep("boot",cl))
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
	if(grep("parametric", b$sim))
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
if(grep("data.frame",cl))
{

	print("Results from data frames returned by opgam")


}
}

}
