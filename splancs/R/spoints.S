spoints <- function(data,npoints)
{
	ldat <- length(data)
	if(missing(npoints)){
		if(ldat%%2 != 0){
			warning("Odd number of data items")
			warning("last one will be ignored")
			ldat <- ldat-1
			data <- data[1:ldat]
		}
		npoints <- ldat/2
	}
	else{
		if(ldat < npoints*2){
			data <- rep(data,length.out=npoints*2)
		}
		else{
			data <- data[1:(npoints*2)]
		}
	}
	matrix(data,ncol=2,byrow=T)	
}

	
	
