      function weight(x,y,r,xp,yp,np)
c
c find the weight for the point at x,y, radius r
c
      implicit real*8 (a-h,o-z)

      include 'bounds.cmn'

      dimension xp(np+1),yp(np+1)

      weight=cncvwt(x,y,r,xp,yp,np)

      return
      end
