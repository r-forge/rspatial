stvmat_function(pts,times,poly,tlim,s,tm)
{
	mathlib.dynam('splancs','stsecal.o')
# full spacetime variance/covariance matrix
	tlow_min(tlim)
        tupp_max(tlim)

	ns_length(s)
        nt_length(tm)
        tm_sort(tm)

	np_npts(poly)
        xp <- c(poly[, 1],poly[1,1])
        yp <- c(poly[, 2],poly[1,2])

	n_npts(pts)
	

	x_pts[, 1]
	y_pts[, 2]
        z_times

        svec_vector(mode="numeric", length=ns)
        tvec_vector(mode="numeric", length=nt)

	smat_matrix(0,ncol=ns,nrow=n)
        tmat_matrix(0,ncol=nt,nrow=n)

        long_ns*nt
        cmat_matrix(0,ncol=long,nrow=long)

slist <- .Fortran("stsecal",
                as.double(x),
                as.double(y),
                as.integer(n),
                as.double(xp),
                as.double(yp),
                as.integer(np),
                as.double(s),
                as.integer(ns),
		as.double(smat),
		as.double(svec),
		as.double(z),
		as.double(tlow),
		as.double(tupp),
		as.double(tm),
		as.integer(nt),
		as.double(tmat),
		as.double(tvec),
		as.integer(long),
		varmat=as.double(cmat)
		)

 ans_matrix(slist$varmat,nrow=long,byrow=T)
 ans_array(ans,dim=c(nt,ns,nt,ns))
ans
}

