stsecal_function(pts,times,poly,tlim,s,tm)
{
bigmat_matrix(stvmat(pts,times,poly,tlim,s,tm),nrow=length(s)*length(tm))
diagon_diag(bigmat)
semat_sqrt(t(matrix(diagon,ncol=length(s))))
semat
}

