
cvkernratio<-function(ccpts, ncases, ncontrols, pbdry, h, edge=TRUE)
{
	nh<-length(h)
	cv<-rep(NA, nh)
	int<-rep(NA, nh)

	idxcases<-1:ncases
	idxcontrols<-ncases+1:ncontrols

	gtfilter<-inpip(as.points(coordinates(gt)), pbdry)
	cellsize<-prod(gt@cellsize)

	for(bw in 1:nh)
	{
		hbw<-h[bw]

		mcases<-matrix(NA, ncol=2, nrow=ncases) 
		for(i in idxcases)
		{
			#print(i)
#mcases[i,1]<-lambdahat(ccpts[idxcases[-i],], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda/(ncases-1)
mcases[i,1]<-kdespat(ccpts[idxcases[-i],], hbw, poly=pbdry, grid=FALSE, x=ccpts[i,1], y=ccpts[i,2], scale=FALSE)/(ncases-1)
#mcases[i,2]<-lambdahat(ccpts[idxcontrols,], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda/ncontrols
mcases[i,2]<-kdespat(ccpts[idxcontrols,], hbw, poly=pbdry, grid=FALSE, x=ccpts[i,1], y=ccpts[i,2], scale=FALSE)/ncontrols
		}


		mcontrols<-matrix(NA, ncol=2, nrow=ncontrols) 
		for(i in idxcontrols)
		{
			#print(i)
#mcontrols[i-ncases,1]<-lambdahat(ccpts[idxcases,], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda/ncases
mcontrols[i-ncases,1]<-kdespat(ccpts[idxcases,], hbw, poly=pbdry, grid=FALSE, x=ccpts[i,1], y=ccpts[i,2], scale=FALSE)/ncases
#mcontrols[i-ncases,2]<-lambdahat(ccpts[idxcontrols[-(i-ncases)],], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda/(ncontrols-1)
mcontrols[i-ncases,2]<-kdespat(ccpts[idxcontrols[-(i-ncases)],], hbw, poly=pbdry, grid=FALSE, x=ccpts[i,1], y=ccpts[i,2], scale=FALSE)/ncontrols
		}


		rcases<-log(mcases[,1]/mcases[,2])		
		rcontrols<-log(mcontrols[,1]/mcontrols[,2])

#		int[bw]<-computeint(ccpts[idxcases,], ccpts[idxcontrols,], pbdry, hbw, gt, gtfilter, cellsize)
		int[bw]<-computeint2(ccpts[idxcases,], ccpts[idxcontrols,], pbdry, hbw)

cv[bw]<- -int[bw] -(2/ncases)*sum(rcases/mcases[,1]) + (2/ncontrols)*sum(rcontrols/mcontrols[,2])

	print(hbw)
	}

	return(list(int, cv))
}


computeint<-function(cases, controls, pbdry, bw, gt, gtfilter, cellsize, edge=FALSE){

#	kcases<-spkernel2d(cases, pbdry, h0=bw, gt)/nrow(cases)
#	kcontrols<-spkernel2d(controls, pbdry, h0=bw, gt)/nrow(controls)
#	kratio<- log(kcases[gtfilter]/kcontrols[gtfilter])

	kcases<-lambdahat(cases, bw, as.points(coordinates(gt)[gtfilter,]), pbdry, edge=edge)$lambda/nrow(cases)
	kcontrols<-lambdahat(controls, bw, as.points(coordinates(gt)[gtfilter,]), pbdry, edge=edge)$lambda/nrow(controls)

	kratio<- log(kcases/kcontrols)

	int<-  sum(kratio*kratio, na.rm=TRUE)*cellsize

	return(int)

}

#CV for the binary regression estimator
cvbinreg<-function(ccpts, ncases, ncontrols, pbdry, h, edge=FALSE)
{
	nh<-length(h)
	cv<-rep(NA, nh)
	n<-ncases+ncontrols

	y<-c(rep(1, ncases), rep(0, ncontrols))
	idxcases<-1:ncases
	idxcontrols<-ncases+1:ncontrols

	setkernel("gaussian")
	
	for(bw in 1:nh)
	{
		hbw<-h[bw]

		mcases<-matrix(NA, ncol=2, nrow=ncases) 
		for(i in idxcases)
		{
mcases[i,1]<-lambdahat(ccpts[idxcases[-i],], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda
mcases[i,2]<-lambdahat(ccpts[idxcontrols,], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda
		}


		mcontrols<-matrix(NA, ncol=2, nrow=ncontrols) 
		for(i in idxcontrols)
		{
mcontrols[i-ncases,1]<-lambdahat(ccpts[idxcases,], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda
mcontrols[i-ncases,2]<-lambdahat(ccpts[idxcontrols[-(i-ncases)],], hbw, matrix(ccpts[i,], ncol=2), pbdry, edge=edge)$lambda
		}


		pcases<-mcases[,1]/(mcases[,1]+mcases[,2])
		pcontrols<-mcontrols[,1]/(mcontrols[,1]+mcontrols[,2])


		cv[bw]<- (-1/n)*sum(c(log(pcases), log(1-pcontrols)))

	print(hbw)
	}

	return(exp(cv))
}



#Compute the integral using adapt


logr<-function(pts, cases, controls, pbdry, bw, edge=FALSE)
{

	pts<-matrix(pts, ncol=2)

	if(!inout(pts, pbdry))
	{
		kratio<-0
	}
	else
	{
        kcases<-lambdahat(cases, bw, pts, pbdry, edge=edge)$lambda/nrow(cases)
        kcontrols<-lambdahat(controls, bw, pts, pbdry, edge=edge)$lambda/nrow(controls)

        kratio<- log(kcases/kcontrols)
	}

	return(kratio*kratio)
}




computeint2<-function(cases, controls, pbdry, bw)
{
	int<-adapt(2, apply(pbdry,2,min),  apply(pbdry,2,max), functn=logr,
		cases=cases, controls=controls, pbdry=pbdry, bw=bw)

        return(int$value)
}



