khvc_function(pts1,pts2,poly,s)
{
	mathlib.dynam('splancs','khvc.o')
	anslist_list(0,0,0,0)
        names(anslist) <- c('varmat','k11','k12','k22')
	ns_length(s)

	np_npts(poly)
        xp <- c(poly[, 1],poly[1,1])
        yp <- c(poly[, 2],poly[1,2])

	n1_npts(pts1);n2_npts(pts2);n_n1+n2
	
	x_c(pts1[, 1], pts2[, 1])
	y_c(pts1[, 2], pts2[, 2])

        bvec_vector(mode="numeric", length=ns)
	table_matrix(0,ncol=ns,nrow=n)
        cmat_matrix(0,ncol=ns,nrow=ns)
        v11_vector(mode='numeric',length=ns)
        v12_vector(mode='numeric',length=ns)
	v22_vector(mode='numeric',length=ns)

slist <- .Fortran("khvc",
                as.double(x),
                as.double(y),
                as.integer(n),
                as.integer(n1),
                as.integer(n2),
                as.double(xp),
                as.double(yp),
                as.integer(np),
                as.double(s),
                as.integer(ns),
		as.double(table),
		as.double(bvec),
		vark1=as.double(v11),
		vark12=as.double(v12),
		vark2=as.double(v22),
		covmat=as.double(cmat)
		)

 ans_matrix(slist$covmat,nrow=ns,byrow=T)
anslist$varmat_ ans
anslist$k11_slist$vark1
anslist$k12_slist$vark12
anslist$k22_slist$vark2
anslist
}

