khvmat_function(pts1,pts2,poly,s)
{
	mathlib.dynam("splancs","khvmat.o")
	ns_length(s)

	np_npts(poly)
        xp <- c(poly[, 1],poly[1,1])
        yp <- c(poly[, 2],poly[1,2])

	n1_npts(pts1);n2_npts(pts2);n_n1+n2
	

	smax_max(s)
	x_c(pts1[, 1], pts2[, 1])
	y_c(pts1[, 2], pts2[, 2])
        bvec_vector(mode="numeric", length=ns)
	table_matrix(0,ncol=ns,nrow=n)
        cmat_matrix(0,ncol=ns,nrow=ns)

slist <- .Fortran("khvmat",
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
		varmat=as.double(cmat)
		)

ans_matrix(slist$varmat,nrow=ns,byrow=T)
ans_ans+t(ans)
diag(ans)_diag(ans)/2

ans

}
