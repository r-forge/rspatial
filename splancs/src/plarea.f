C Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
C Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
C R port: copyright 1998-2000 by Roger S. Bivand
C
C  This program is free software; you can redistribute it and/or modify
C  it under the terms of the GNU General Public License as published by
C  the Free Software Foundation; either version 2 of the License, or
C  (at your option) any later version.
C
C  This program is distributed in the hope that it will be useful,
C  but WITHOUT ANY WARRANTY; without even the implied warranty of
C  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C  GNU General Public License for more details.


c-------------------------------------------------------------------------
      function plarea(xp,yp,np)
c-------------------------------------------------------------------------
c
c find the area of the polygon defined by points in xp,yp
c
      implicit real*8 (a-h,o-z)

      dimension xp(np+1),yp(np+1)

      totare=0

      do is=1,np

        x1=xp(is)
        y1=yp(is)

        if(is.eq.np)then
          x2=xp(1)
          y2=yp(1)
        else
          x2=xp(is+1)
          y2=yp(is+1)
        end if

c Find the area of the trapezium
        totare = totare + (x2-x1)*(y2+y1)/2.0

      end do

c return a positive value
      plarea = abs(totare)

      end

