pip <- function(pts,poly,out=F)
{
	inoutv <- inout(pts,poly)
	if(!out){
		res <- pts[inoutv==T,,drop=F]
	}
	else{
		res <- pts[inoutv==F,,drop=F]
	}
	res
}

