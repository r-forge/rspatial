dsquare <- 
function(pts, srcs, namepref="d")
{
  ptsxy_as.points(pts)
  nameso_names(pts)
	d <- NULL
	nsrcs <- npts(srcs)
	for(i in 1:nsrcs) {
		d <- cbind(d, (srcs[i, 1] - ptsxy[,1])^2 + (srcs[i, 2] - 
			ptsxy[,2])^2)
		nameso_c(nameso,paste(namepref,i,sep=''))
	}
	res_as.data.frame(d)
        names(res)_nameso
        res
}

# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
