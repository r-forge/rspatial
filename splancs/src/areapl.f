      subroutine areapl(xp,yp,np,plar)
c
c return the area of the polygon as one of the arguments of the sub
c 
      implicit real*8(a-h,o-z)
      dimension xp(np+1),yp(np+1)
      plar=plarea(xp,yp,np)
      return
      end
      
