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


      function ipippa(x,y,xc,yc,nc)
c 
c point in polygon routine.
c
c returns 0 if point x,y not in the bound polygon defined by xc,yc
c
c fortran version of C routine by Ken McElvain
c

      implicit real*8 (a-h,o-z)
      include 'bounds.cmn'


      dimension xc(nc+1),yc(nc+1)

        iwind = 0
        xlastp = xc(nc)
        ylastp = yc(nc)
        ioldq = iquad(xlastp,ylastp,x,y)
        do i=1,nc 
c for each point in the polygon 
                xthisp=xc(i)
                ythisp=yc(i)
                inewq = iquad(xthisp,ythisp,x,y)
                if(ioldq.ne.inewq) then
                        if(mod(ioldq+1,4).eq.inewq) then
                          iwind=iwind+1
                        else if(mod(inewq+1,4).eq.ioldq) then
                          iwind = iwind - 1
                        else 
                          a = (ylastp-ythisp)*(x-xlastp)
                          b = xlastp-xthisp
                          a = a + ylastp * b
                          b=b*y
                             if (a.gt.b) then
                               iwind=iwind+2
                             else
                               iwind=iwind-2
                             end if
                        end if
                end if
                xlastp=xthisp
                ylastp=ythisp
                ioldq=inewq
      end do
c 
c quadrant winding is either -4,0,+4 so divide down and take abs.
c
      ipippa = abs(iwind/4)

      end

      function iquad(xp,yp,xo,yo)
c
c determine which quadrant xp,yp is in relative to xo,yo as origin
c
      implicit real*8 (a-h,o-z)

        if(xp.lt.xo)then
                if(yp.lt.yo) then
                   iquad=2
                else 
                   iquad=1
                end if
        else
                if(yp.lt.yo)then
                   iquad = 3
                else 
                   iquad = 0
                end if
        end if

      return
      end
