mse2d <- function(pts,poly,nsmse,range)
{
	library.dynam("splancs","twodimmse.o")
	ptsx_pts[,1]
	ptsy_pts[,2]
	nptsm_npts(pts)
	
	a1_min(poly[,1],na.rm=T)
	a2_max(poly[,1],na.rm=T)
	b1_min(poly[,2],na.rm=T)
	b2_max(poly[,2],na.rm=T)
	
	hsmse_range/nsmse
	amse_rep(0,nsmse)
	t_rep(0,nsmse)
	
	mselist_.Fortran("mse2d",
		as.double(ptsx),
		as.double(ptsy),
		as.integer(nptsm),
		as.double(a1),
		as.double(a2),
		as.double(b1),
		as.double(b2),
		as.integer(nsmse),
		as.double(hsmse),
		as.double(amse),
		as.double(t)
		)
		
	list(mse=mselist[[10]],h=mselist[[11]])
}
