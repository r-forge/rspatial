"kerview"<-
function(pts,times, k3, map = T,addimg=T,ncol=1)
{
        pts3_cbind(pts,times)
        zgr_k3$zgr
	old.par <- par()
	im.dev <- dev.cur()
	par(mfrow=c(ncol,ncol))
	if(ncol!=1)addimg_F
	image(k3$xgr, k3$ygr, k3$v[,  , 1])
	map.dev <- -999
	if(map) {
		pbox <- bbox(pts3)
		dstring <- paste(names(dev.cur()), 
			"(\"-geometry 500x500-5+5\")", sep = "")
		eval(parse(text = dstring))	
	#  dev.copy(eval(parse(text=names(dev.cur()))),'-geometry=500x500-5+5')
		map.dev <- dev.cur()
		on.exit(if(map.dev != -999) dev.off(map.dev))
		par(pty = "s")
		par(mfrow=c(ncol,ncol))
#		par(mai=c(0,0,0,0))
		pointmap(pts3)
		tmin <- min(pts3[, 3])
		tmax <- max(pts3[, 3])
		tbins <- (zgr[1:(length(zgr) - 1)] + zgr[2:length(zgr)])/2
	#  if(tbins[1] < tmin)tbins_c(tmin,tbins)
#  if(tbins[length(tbins)] > tmax)tbins_c(tbins,tmax)
		pbins <- cut(pts3[, 3], tbins)
	}
#dev.copy(eval(parse(text=names(dev.cur()))),'-geometry=500x250')
	dstring <- paste(names(dev.cur()), "(\"-geometry 700x300+0-5\")", sep
		 = "")
	eval(parse(text = dstring))
	hi.dev <- dev.cur()
	on.exit({
		dev.off(hi.dev)
		if(map.dev != -999)
			dev.off(map.dev)
	}
	)
	hist(pts3[, 3])
	repeat {
		tsl <- locator(1)
		if(length(tsl) == 0)
			break
		tsl <- tsl$x
		bdist <- abs(tsl - k3$zgr)
		bin <- (1:length(k3$zgr))[bdist == min(bdist)]
		bin <- bin[1]
		dev.set(im.dev)
		image(k3$xgr, k3$ygr, k3$v[,  , bin], add = addimg)
		if(map) {
			dev.set(map.dev)
#			ptsin <- pts3[pbins == bin,]
		       ptsin_pts3[abs(pts3[,3]-k3$zgr[bin]) < k3$hz,]
			if(length(ptsin != 0)) {
				pointmap(pbox, type = "n")
				pointmap(ptsin, add = T)
				title(paste("time = ", format(k3$zgr[bin])))
			}
		}
		dev.set(hi.dev)
	}
#dev.off(hi.dev)
	dev.set(im.dev)
}


# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
