kernrat <- function(pts1,pts2,poly,h1,h2,nx=20,ny=20,kernel='quartic')
{
	kern1 <- kernel2d(pts1,poly,h1,nx,ny,kernel)
	kern2 <- kernel2d(pts2,poly,h2,nx,ny,kernel)
	
	list(x=kern1$x,y=kern1$y,z=kern1$z/kern2$z,h=c(h1,h2),kernel=kernel)
}


	
	
