      subroutine v(x,y,n,n1,xp,yp,np,s,ns,R,Z,t,U,a,b,c,d,e,f,g,h,o,p,q)

      implicit real*8 (a-h,o-z)

      include 'bounds.cmn'

      dimension x(n),y(n),s(ns+1),xp(np+1),yp(np+1),a(ns),b(ns)
      dimension R(n,ns),Z(n1,ns),t(n1,ns),U(n1,ns),c(ns),d(ns),e(ns)
      dimension h(ns),o(ns),p(ns),q(ns),f(ns),g(ns)
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
              do k=1,2
               if (i.eq.k*n1+j) then
                vij=0
               end if
              end do
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
              do k=1,2
               if (i.eq.k*n1+j) then
                vij=0
               end if
              end do


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
        do k=0,2
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


c
      do l=1,ns
       c(l)=0
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
              do k=1,2
               if (i.eq.k*n1+j) then
                vij=0
               end if
              end do


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
        c(l)=c(l)+R(i,l)
        end do
      end do


      do l=1,ns
        a(l)=0
      end do
      do i=2,n1
       do j=1,i-1
        do i1=1,n1
         do l=1,ns
          Z(i1,l)=0
         end do
        end do
        do k=0,2
          l=i+n1*k
         do k1=0,2
            k2=j+n1*k1
            dlk2=(x(l)-x(k2))**2+(y(l)-y(k2))**2
            if (dlk2.le.(s(ns))**2) then
               rdlk2=dsqrt(dlk2)
               wlk2=weight(x(l),y(l),rdlk2,xp,yp,np)
               wk2l=weight(x(k2),y(k2),rdlk2,xp,yp,np)
               vlk2=(wlk2+wk2l)/2

               m=iplace(s,ns,rdlk2)
c               call intpr('m= ',-1,m,1)
               do kv=m,ns
                 Z(i,kv)=Z(i,kv)+vlk2
                 Z(j,kv)=Z(j,kv)+vlk2
               end do

            end if
         end do
        end do
        do i1=1,n1
          do l=1,ns
            a(l)=a(l)+Z(i1,l)**2
          end do
        end do
       end do
      end do


      do i=1,n1
       do l=1,ns
        t(i,l)=0
       end do
      end do
      do i=1,n1
       do l=1,ns
        Z(i,l)=0
       end do
      end do
      do l=1,ns
        d(l)=0
      end do
      do i=1,n1
            j=i+n1
            k=i+2*n1
            dkj=(x(k)-x(j))**2+(y(k)-y(j))**2
         if (dkj.le.(s(ns))**2) then
              rdkj=dsqrt(dkj)
              wkj=weight(x(k),y(k),rdkj,xp,yp,np)
              wjk=weight(x(j),y(j),rdkj,xp,yp,np)
              vkj=(wkj+wjk)/2
              m=iplace(s,ns,rdkj)
c               call intpr('m= ',-1,m,1)
            do l=m,ns
              Z(i,l)=vkj
            end do
         end if
      end do
      do i=1,n1
         do k=1,2
           j=i+n1*k
           dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=(wij+wji)/2

               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
              do l=m,ns
                  t(i,l)=t(i,l)+vij
              end do
            end if
         end do
      end do
      do i=1,n1
       do l=1,ns
           d(l)= d(l)+Z(i,l)+t(i,l)
       end do
      end do



      do i=1,n1
       do l=1,ns
        t(i,l)=0
       end do
      end do
      do l=1,ns
        g(l)=0
      end do
      do i=1,n1
            j=i+n1
            k=i+2*n1
            dkj=(x(k)-x(j))**2+(y(k)-y(j))**2
         if (dqj.le.(s(ns))**2) then
              rdkj=dsqrt(dkj)
              wkj=weight(x(k),y(k),rdkj,xp,yp,np)
              wjk=weight(x(j),y(j),rdkj,xp,yp,np)
              vkj=(wkj+wjk)/2
              m=iplace(s,ns,rdkj)
c               call intpr('m= ',-1,m,1)
            do l=m,ns
              Z(i,l)=vkj
            end do
         end if
      end do
      do i=1,n1
         do k=1,2
           j=i+n1*k
           dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=(wij+wji)/2

               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  t(i,l)=t(i,l)+vij
               end do
            end if
         end do
      end do
      do l=1,ns
       g(l)=0
      end do
      do i=1,n1
         do l=1,ns
           g(l)=g(l)+(Z(i,l)+t(i,l))**2
         end do
      end do


      do i=1,n1
        do l=1,ns
         t(i,l)=0
        end do
      end do
      do i=1,n1
            j=i+n1
            k=i+2*n1
            dkj=(x(k)-x(j))**2+(y(k)-y(j))**2
         if (dkj.le.(s(ns))**2) then
              rdkj=dsqrt(dkj)
              wkj=weight(x(k),y(k),rdkj,xp,yp,np)
              wjk=weight(x(j),y(j),rdkj,xp,yp,np)
              vkj=(wkj+wjk)/2
              m=iplace(s,ns,rdkj)
c               call intpr('m= ',-1,m,1)
            do l=m,ns
              Z(i,l)=vkj
            end do
         end if
      end do
      do i=1,n1
         do k=1,2
           j=i+n1*k
           dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=(wij+wji)/2

               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  t(i,l)=t(i,l)+vij
               end do
            end if
         end do
      end do
      do l=1,ns
        f(l)=0
      end do
      do i=2,n1
       do j=1,i-1
        do i1=1,n1
         do l=1,ns
          U(i1,l)=0
         end do
        end do
        do k=0,2
          l=i+n1*k
         do k1=0,2
            k2=j+n1*k1
            dlk2=(x(l)-x(k2))**2+(y(l)-y(k2))**2
            if (dlk2.le.(s(ns))**2) then
               rdlk2=dsqrt(dlk2)
               wlk2=weight(x(l),y(l),rdlk2,xp,yp,np)
               wk2l=weight(x(k2),y(k2),rdlk2,xp,yp,np)
               vlk2=(wlk2+wk2l)/2

               m=iplace(s,ns,rdlk2)
c               call intpr('m= ',-1,m,1)
               do kv=m,ns
                 U(i,kv)=U(i,kv)+vlk2
                 U(j,kv)=U(j,kv)+vlk2
               end do

            end if
         end do
        end do
         do kp=1,n1
          do l=1,ns
            f(l)=f(l)+U(kp,l)*(Z(kp,l)+t(kp,l))
          end do
         end do
       end do
      end do



      do i=1,n1
       do l=1,ns
        t(i,l)=0
       end do
      end do
      do l=1,ns
        q(l)=0
      end do
      do i=1,n1
            j=i+n1
            k=i+2*n1
            dkj=(x(k)-x(j))**2+(y(k)-y(j))**2
            if (dqj.le.(s(ns))**2) then
               rdkj=dsqrt(dkj)
               wkj=weight(x(k),y(k),rdkj,xp,yp,np)
               wjk=weight(x(j),y(j),rdkj,xp,yp,np)
                 vkj=(wkj+wjk)/2

               m=iplace(s,ns,rdkj)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                 Z(i,l)=vkj*vkj
               end do
            end if
      end do
      do i=1,n1
         do k=1,2
           j=i+n1*k
           dij=(x(i)-x(j))**2+(y(i)-y(j))**2
            if (dij.le.(s(ns))**2) then
               rdij=dsqrt(dij)
               wij=weight(x(i),y(i),rdij,xp,yp,np)
               wji=weight(x(j),y(j),rdij,xp,yp,np)
               vij=(wij+wji)/2

               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  t(i,l)=t(i,l)+vij*vij
               end do
            end if
         end do
      end do

      do i=1,n1
       do l=1,ns
         q(l)= q(l)+Z(i,l)+t(i,l)
       end do
      end do





      do i=1,n1
       do l=1,ns
        Z(i,l)=0
       end do
      end do
      do l=1,ns
         o(l)=0.0d0
      end do
      do i=2,n1
          do j=1,i-1
           do k=0,2
            k1=i+n1*k
            do i1=1,n1
             do l=1,ns
              Z(i1,l)=0
             end do
            end do
            do k2=0,2
             k3=j+n1*k2
             drq=(x(k1)-x(k3))**2+(y(k1)-y(k3))**2
              if (drq.le.(s(ns))**2) then
               rdk1k3=dsqrt(drq)
               wk1k3=weight(x(k1),y(k1),rdk1k3,xp,yp,np)
               wk3k1=weight(x(k3),y(k3),rdk1k3,xp,yp,np)
               vk1k3=(wk1k3+wk3k1)/2

               m=iplace(s,ns,rdk1k3)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                 Z(1,l)=Z(1,l)+vk1k3
               end do

              end if
            end do
            do l=1,ns
             o(l)=o(l)+Z(1,l)*Z(1,l)*2
            end do
           end do
          end do
      end do




      do l=1,ns
       h(l)=0
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
              do k=1,2
               if (i.eq.k*n1+j) then
                vij=0
               end if
              end do


               m=iplace(s,ns,rdij)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                  R(i,l)=R(i,l)+vij**2
                  R(j,l)=R(j,l)+vij**2
               end do

            end if
         end do
      end do
      do l=1,ns
           do i=1,n
              h(l)=h(l)+R(i,l)
           end do
      end do



      do l=1,ns
        p(l)=0
      end do
      do i=1,n1
        do l=1,ns
          Z(i,l)=0
        end do
      end do
      do i=1,n1
            j=i+n1
            k=i+2*n1
            dkj=(x(k)-x(j))**2+(y(k)-y(j))**2
            if (dkj.le.(s(ns))**2) then
               rdkj=dsqrt(dkj)
               wkj=weight(x(k),y(k),rdkj,xp,yp,np)
               wjk=weight(x(j),y(j),rdkj,xp,yp,np)
                 vkj=(wkj+wjk)/2

               m=iplace(s,ns,rdkj)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                 Z(i,l)=vkj
               end do
            end if
      end do
      do i=1,n1
        do l=1,ns
          t(i,l)=0
        end do
      end do
      do i=1+n1,n1+n1
            j=i-n1
            k=i+n1
            dkj=(x(k)-x(j))**2+(y(k)-y(j))**2
            if (dkj.le.(s(ns))**2) then
               rdkj=dsqrt(dkj)
               wkj=weight(x(k),y(k),rdkj,xp,yp,np)
               wjk=weight(x(j),y(j),rdkj,xp,yp,np)
                 vkj=(wkj+wjk)/2

               m=iplace(s,ns,rdkj)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                 t(j,l)=vkj
               end do
            end if
      end do

      do i=1,n1
        do l=1,ns
          U(i,l)=0
        end do
      end do
      do i=2*n1+1,n
            j=i-n1
            k=i-2*n1
            dkj=(x(k)-x(j))**2+(y(k)-y(j))**2
            if (dkj.le.(s(ns))**2) then
               rdkj=dsqrt(dkj)
               wkj=weight(x(k),y(k),rdkj,xp,yp,np)
               wjk=weight(x(j),y(j),rdkj,xp,yp,np)
                 vkj=(wkj+wjk)/2

               m=iplace(s,ns,rdqj)
c               call intpr('m= ',-1,m,1)
               do l=m,ns
                 U(k,l)=vkj
               end do
            end if
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
              do k=1,2
               if (i.eq.k*n1+j) then
                vij=0
               end if
              end do


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
       do l=1,ns
        p(l)=p(l)+R(i,l)*Z(i,l)
       end do
      end do
      do j=n1+1,n1*2
       i=j-n1
        do l=1,ns
         p(l)=p(l)+R(j,l)*t(i,l)
        end do
      end do
      do k=2*n1+1,n
       i=k-2*n1
        do l=1,ns
         p(l)=p(l)+R(k,l)*t(i,l)
        end do
      end do
      dnn=162*(dn1*(dn1-1)*(2*dn1-1))**2
      do l=1,ns
      a(l)=(3*dn1-1)**2*(a(l)+9*h(l)-6*o(l))
      b(l)=(3*dn1-2)**2*(-8*b(l)+24*e(l))
      h(l)=(dn1-1)**2*(-18*g(l)+54*q(l)+18*d(l)**2)+2*c(l)**2
      g(l)=(dn1-1)*(-12*d(l)*c(l)+24*(3*dn1-2)*f(l)-72*(3*dn1-2)*p(l))
      e(l)=area*(a(l)+b(l)+h(l)+g(l))/dnn
      end do
c      call dblepr('e = ',-1,e(l),1)


      return
      end