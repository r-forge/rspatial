plot.SpatialRings<-function(object, col, border=NULL, ...)
{
        #Spatial dimension of the object
#        n = dimensions(object)
#        if(n!=2)
#                stop("This function can only plot spatial objects of dimension 2")

        #Take the length of the polylist
        npoly<-length(object@polygons)

        #Set up filling and border colours
        col<-rep(col,length.out=npoly)  
        
        if(is.null(border))
                border<-rep("black", length(col))
        else
                border<-rep(border, length.out=npoly)


#Set aspect ratio and display plotting window

#        par.in <- par(no.readonly = TRUE)
#       on.exit(par(par.in))

        bbox<-object@bbox
        
#        plot.dim<-c(bbox[1,"max"]-bbox[1,"min"], bbox[2,"max"]-bbox[2,"min"])

#        rdib<-min(par.in$pin[1]/plot.dim[1],par.in$pin[2]/plot.dim[2])
#        plotreg<-c(bbox[1,"min"],bbox[1,"min"]+plot.dim[[1]]*rdib,
#                        bbox[2,"min"],bbox[2,"min"]+plot.dim[[2]]*rdib)
#        par(pin=c(xratio,yratio)*plot.dim*rdib, usr=plotreg)

#Set up plotting window

#        plot(0,0,xlim=c(bbox[1,"min"],bbox[1,"max"]), 
#                ylim=c(bbox[2,"min"],bbox[2,"max"]), type="n", asp=1, ...)     
	plot.new()
	plot.window(xlim=c(bbox[1,1], bbox[1,2]), ylim=c(bbox[2,1], bbox[2,2]), asp=1)

#Plot the polygons
        for(p in 1:npoly)
        {

                coords<-object@polygons[[p]]@coords
                polyidx<-c(0, which(is.na(coords[,1])==TRUE), nrow(coords)+1)

                #Plot polygons (allowing for multiple islands)
                for(pp in 1:(length(polyidx)-1))
                {
                        idx<-(polyidx[pp]+1):(polyidx[pp+1]-1)
                        polygon(coords[idx,1], coords[idx,2], col=col[p], 
                                border=border[p])
                }
        }
}


