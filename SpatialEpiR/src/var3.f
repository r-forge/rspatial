      subroutine v1(x,y,n,n1,xp,yp,np,s,ns,R,Z,a,b,e)

      implicit real*8 (a-h,o-z)

      include 'bounds.cmn'

      dimension x(n),y(n),s(ns+1),xp(np+1),yp(np+1),a(ns),b(ns)
      dimension R(n,ns),Z(n1,ns),e(ns)

c
c     sample variances  of K11(s)-K22(s) under random labelling
c     Algorithm A G Chetwynd  P J Diggle

      area=plarea(xp,yp,np)
      area=area**2
      dn1=dfloat(n1)
      dn=dfloat(n)


      do l=1,ns
       e(l)=0
      end do
      do i=2,n
         do j=1,i-1
            dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=(wij+wji)/2
               if (i.eq.n1+j) then
                vij=0
               end if
               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  R(i,l)=R(i,l)+vij
                  R(j,l)=R(j,l)+vij
               end do

            end if
         end do
      end do
      do i=1,n
        do l=1,ns
          e(l)=e(l)+R(i,l)*R(i,l)
        end do
      end do



      do l=1,ns
        b(l)=0
      end do
      do i=1,n
        do l=1,ns
         R(i,l)=0
        end do
      end do
      do i=2,n
         do j=1,i-1
            dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=(wij+wji)/2
               if (i.eq.n1+j) then
                vij=0
               end if


               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  R(i,l)=R(i,l)+vij
                  R(j,l)=R(j,l)+vij
               end do

            end if
         end do
       end do
       do i=1,n1
        do k=0,1
              j=i+n1*k
         do l=1,ns
              Z(i,l)=Z(i,l)+R(j,l)
         end do
        end do
       end do
       do i=1,n1
         do l=1,ns
           b(l)=b(l)+Z(i,l)**2
         end do
       end do

      dnn=dn1**2*(dn1-1)**2
      do l=1,ns
      a(l)=area*(2*e(l)-b(l))/dnn
      end do

c      call dblepr('a = ',-1,a(l),1)


      return
      end