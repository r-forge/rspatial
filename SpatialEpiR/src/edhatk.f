      subroutine edhatk(x,y,n,n1,n2,xp,yp,np,s,ns,Amt,Bmt,bgu,bgv,bgw,k)

      implicit real*8 (a-h,o-z)

      include 'bounds.cmn'

      dimension x(n),y(n),s(ns+1),xp(np+1),yp(np+1)
      dimension Amt(n,ns),Bmt(n,ns),bgw(ns),bgu(ns),bgv(ns)

      area=plarea(xp,yp,np)
      dn1=dfloat(n1)
      dn2=dfloat(n2)
      dn=dfloat(n)
      dn12=dn1*(dn1-1.0d0)
      dn22=dn2*(dn2-1.0d0)

      do i=1,ns
      bgu(i)=0.0d0
      bgv(i)=0.0d0
      end do

      do i=2,n
         do j=1,i-1
            dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=(wij+wji)/2
              do p=1,k-1
               if (i.eq.p*n1+j) then
                vij=0
               end if
              end do


               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  Amt(i,l)=Amt(i,l)+vij
                  Amt(j,l)=Amt(j,l)+vij
               end do

            end if
         end do
      end do
      do l=1,ns
           do i=1,n
              bgu(l)=bgu(l)+Amt(i,l)
           end do
      end do

      do i=2,n

         do j=1,i-1

            dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=0
              do p=1,k-1
                if (i.eq.p*n1+j) then
                 vij=(wij+wji)/2
                end if
              end do

               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  Bmt(i,l)=Bmt(i,l)+vij
                  Bmt(j,l)=Bmt(j,l)+vij
               end do

            end if

         end do


      end do
      do l=1,ns
           do i=1,n
              bgv(l)=bgv(l)+Bmt(i,l)
           end do
      end do
      dnn=k*k*dn1*(dn1-1.0d0)*(k-1)*((k-1)*dn1-1.0d0)
      do l=1,ns
      bgw(l)= area*((k-1)*(k-2)*bgu(l)-k*(dn1-1.0d0)*(k-2)*bgv(l))/(dnn)
c      call dblepr('bgw = ',-1,bgw(k),1)
      end do
      return
      end