stsecal <- function(pts,times,poly,tlim,s,tm)
{
bigmat <- matrix(stvmat(pts,times,poly,tlim,s,tm),nrow=length(s)*length(tm))
diagon <- diag(bigmat)
semat <- sqrt(t(matrix(diagon,ncol=length(s))))
semat
}

