#
#This function produces a pretty output of the boot object created by
#varios tests
#

dcluster.test<-function(b)
{
	print("CHECK if we have a boot object or a data.frame or WHAT!!")


	#Parameters used in the call to boot(...)
	p<-as.character(b$call)

	#Test computed
	test<-strsplit(p[3], ".", fixed=TRUE)

	if(grep("moran", p))
	{
	print("Results of Moran's I test for spatial autocorrelation")
	print("-------->Type of boots.")
	print("-------->Model used when sampling")
	print(c("Number of simulations:", b$R))
	print(c("Statistic: ", b$t0))
	print(c("p-value : ", (1+sum(b$t0<b$t))/(b$R+1)))
	}

}
