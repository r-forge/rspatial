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



      subroutine dokhat(x,y,n,xp,yp,np,s,ns,hkhat)

      implicit real*8(a-h,o-z)

      include 'bounds.cmn'

      dimension x(n),y(n),xp(np+1),yp(np+1),s(ns),hkhat(ns)

      area = plarea(xp,yp,np)

      pi=3.141592654d0

      tmax=(s(ns))**2  

      do i=1,ns
        hkhat(i)=0.0d0
      end do

      do i=2,n
        i1=i-1                                                                
        xi=x(i)                                                              
        yi=y(i)                                                              
        do  j=1,i1                                                           
          xj=xi-x(j)                                                           
          yj=yi-y(j)                                                           
          t=xj*xj+yj*yj                                                         
          if (t.lt.tmax) then                                                 

            t=dsqrt(t)
            it=iplace(s,ns,t) 
 
            if(it.le.ns) then
              wij=weight(xi,yi,t,xp,yp,np)
              wji=weight(x(j),y(j),t,xp,yp,np)
            end if

            hkhat(it)=hkhat(it)+wij+wji
          end if
        end do
      end do

      do i=2,ns
        hkhat(i)=hkhat(i)+hkhat(i-1)
      end do

      dn=dfloat(n)*dfloat(n-1)

      do i=1,ns                                              
        hkhat(i)=hkhat(i)*area/dn
      end do

      return                                                                
      end

