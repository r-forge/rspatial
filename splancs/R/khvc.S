# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#

khvc <- function(pts1,pts2,poly,s)
{
#	mathlib.dynam('splancs','khvc.o')
	anslist <- list(0,0,0,0)
        names(anslist) <- c('varmat','k11','k12','k22')
	ns <- length(s)

	np <- npts(poly)
        xp <- c(poly[, 1],poly[1,1])
        yp <- c(poly[, 2],poly[1,2])

	n1 <- npts(pts1);n2 <- npts(pts2);n <- n1+n2
	
	x <- c(pts1[, 1], pts2[, 1])
	y <- c(pts1[, 2], pts2[, 2])

        bvec <- vector(mode="numeric", length=ns)
	table <- matrix(0,ncol=ns,nrow=n)
        cmat <- matrix(0,ncol=ns,nrow=ns)
        v11 <- vector(mode='numeric',length=ns)
        v12 <- vector(mode='numeric',length=ns)
	v22 <- vector(mode='numeric',length=ns)

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

 ans <- matrix(slist$covmat,nrow=ns,byrow=T)
anslist$varmat <-  ans
anslist$k11 <- slist$vark1
anslist$k12 <- slist$vark12
anslist$k22 <- slist$vark2
anslist
}

