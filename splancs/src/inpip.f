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


      subroutine inpip(xpts,ypts,npts,xpoly,ypoly,npoly,lind)

      real*8 xpts(npts),ypts(npts)
      real*8 xpoly(npoly+1),ypoly(npoly+1)

      logical lind(npts)

      do i=1,npts
        if(ipippa(xpts(i),ypts(i),xpoly,ypoly,npoly).eq.0) then
          lind(i)=.FALSE.
        else
          lind(i)=.TRUE.
        end if
      end do

      end
