as.points <- function(...)
{
	nv_nargs()
	fargs_list(...)
	if(nv==2){
		l1_length(fargs[[1]])
		l2_length(fargs[[2]])
		if(l1==l2){
			pts_cbind(fargs[[1]],fargs[[2]])
		}
		else{
			stop("Cannot make points from different length vectors")
		}
		
	}
	else{
		if(nv==1){
			if(is.list(fargs[[1]])){
				fargs_fargs[[1]]
				if(any(names(fargs)=="x") & any(names(fargs)=="y")){
					arx_fargs$x
					ary_fargs$y
					if(length(arx)!=length(ary)){
						stop("Cannot make points from different length x and y list components!")
					}
					else{
						pts_cbind(arx,ary)
					}
				}
				else{
					stop("Cannot make points from list without x and y components.")
				}
			}
			else{
				if(is.points(fargs[[1]]))pts_fargs[[1]]
				else stop("Cannot make points from this object")
			}
		
		}
		else{
			stop("Cannot make object into points!")
		}
	}

	pts
}
