C Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
C Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
C R port: copyright 1998-2002 by Roger S. Bivand
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



C      subroutine dokhat(x,y,n,xp,yp,np,s,ns,hkhat)
C
C      implicit real*8(a-h,o-z)
C
C      include 'bounds.cmn'
C
C      dimension x(n),y(n),xp(np+1),yp(np+1),s(ns),hkhat(ns)
C
C      area = plarea(xp,yp,np)
C
C      pi=3.141592654d0
C
C      tmax=(s(ns))**2  
C
C      do i=1,ns
C        hkhat(i)=0.0d0
C      end do
C
C      do i=2,n
C        i1=i-1                                                                
C        xi=x(i)                                                              
C        yi=y(i)                                                              
C        do  j=1,i1                                                           
C          xj=xi-x(j)                                                           
C          yj=yi-y(j)                                                           
C          t=xj*xj+yj*yj                                                         
C          if (t.lt.tmax) then                                                 
C
C            t=dsqrt(t)
C            it=iplace(s,ns,t) 
C 
C            if(it.le.ns) then
C              wij=weight(xi,yi,t,xp,yp,np)
C              wji=weight(x(j),y(j),t,xp,yp,np)
C            end if
C
C            hkhat(it)=hkhat(it)+wij+wji
C          end if
C        end do
C      end do
C
C      do i=2,ns
C        hkhat(i)=hkhat(i)+hkhat(i-1)
C      end do
C
C      dn=dfloat(n)*dfloat(n-1)
C
C      do i=1,ns                                              
C        hkhat(i)=hkhat(i)*area/dn
C      end do
C
C      return                                                                
C      end
      subroutine trykh(x,y,n,xp,yp,np,s,ns,hkhat,icounts,hkhats,nptns)

      implicit real*8(a-h,o-z)

      include 'bounds.cmn'

      dimension x(n),y(n),xp(np+1),yp(np+1),s(ns),hkhat(ns)
      dimension icounts(nptns), hkhats(nptns)

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

              hkhat(it)=hkhat(it)+wij+wji
              ipos=n*(it-1)
              hkhats(i+ipos)=hkhats(i+ipos) + wij
              hkhats(j+ipos)=hkhats(j+ipos) + wji
              icounts(i+ipos)=icounts(i+ipos) + 1
              icounts(j+ipos)=icounts(j+ipos) + 1
            end if
          end if
        end do
      end do

      do i=2,ns
        hkhat(i)=hkhat(i)+hkhat(i-1)
        do j=1,n
          jj=j+(n*(i-1))
          jj1=j+(n*(i-2))
          hkhats(jj)=hkhats(jj)+hkhats(jj1)
        end do
      end do

      dn=dfloat(n)*dfloat(n-1)
      adn=area/dn

      do i=1,ns                                              
        hkhat(i)=hkhat(i)*adn
        do j=1,n
          jj=j+(n*(i-1))
          hkhats(jj)=hkhats(jj)*adn
        end do
      end do

      return                                                                
      end
