pip <- function(pts,poly,out=F)
{
	inoutv_inout(pts,poly)
	if(!out){
		res_pts[inoutv==T,,drop=F]
	}
	else{
		res_pts[inoutv==F,,drop=F]
	}
	res
}

