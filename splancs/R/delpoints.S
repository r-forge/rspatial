delpoints <- function(pts,add=F,...)
{
	if(!add)pointmap(pts)
	cat("Use button 1 to delete points - button 2 when finished.\n")
	deld <- identify(pts[,1],pts[,2],atpen=F,offset=0,labels=rep("X",length(pts[,1])))
	if(length(deld)!=0){
		pts <- pts[-deld,]
		}
	pts
}

