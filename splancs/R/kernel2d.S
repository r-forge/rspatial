kernel2d <- function(pts,poly,h0,nx=20,ny=20,kernel='quartic')
{
	if(!is.points(pts))stop('Invalid points argument')
	
	if(!is.points(poly))stop('Invalid poly argument')
	
	nptsk_npts(pts)
	npoly_length(poly[,1])
	poly_rbind(poly,c(poly[1,1],poly[1,2]))
	
	
	xrang_range(poly[,1],na.rm=T)
	yrang_range(poly[,2],na.rm=T)
	
	bb_bbox(poly)
	a1_xrang[1]
	a2_xrang[2]
	b1_yrang[1]
	b2_yrang[2]
	cat("Xrange is ",a1,a2,"\n")
	cat("Yrange is ",b1,b2,"\n")
	xgrid_rep(0,nx)
	ygrid_rep(0,ny)
	zgrid_matrix(0,nx,ny)
	if(kernel=='quartic')
	{
		cat('Doing quartic kernel\n')
		library.dynam('splancs','krnqrt.o')
		storage.mode(zgrid)_"double"
		klist_.Fortran("krnqrt",
			as.double(pts[,1]),
			as.double(pts[,2]),
			as.integer(nptsk),
			as.double(poly[,1]),
			as.double(poly[,2]),
			as.integer(npoly),
			as.double(h0),
			as.double(a1),
			as.double(a2),
			as.double(b1),
			as.double(b2),
			as.integer(nx),
			as.integer(ny),
			xgrid=as.double(xgrid),
			ygrid=as.double(ygrid),
			zgrid=(zgrid)
			)
		klist$zgrid[klist$zgrid<0]_NA
		res_list(x=klist$xgrid,y=klist$ygrid,z=klist$zgrid,
			 h0=h0,kernel=kernel)
	}
	else
	{
		stop('Invalid kernel function specification')
	}
res
}

	
	
