spoints <- function(data,npoints)
{
	ldat_length(data)
	if(missing(npoints)){
		if(ldat%%2 != 0){
			warning("Odd number of data items")
			warning("last one will be ignored")
			ldat_ldat-1
			data_data[1:ldat]
		}
		npoints_ldat/2
	}
	else{
		if(ldat < npoints*2){
			data_rep(data,length.out=npoints*2)
		}
		else{
			data_data[1:(npoints*2)]
		}
	}
	matrix(data,ncol=2,byrow=T)	
}

	
	
