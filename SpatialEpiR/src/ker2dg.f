      subroutine ker2dg(h,datx1,datx2,y,w,n,x1,x2,zmat,lpmat,m1,m2)

      implicit   real (a-h, o-z)
      logical    lpmat
      dimension  datx1(n),datx2(n),y(n),w(n),x1(m1),x2(m2),zmat(m1,m2),
     +           lpmat(m1,m2)

      do 10 j=1,m1
         do 20 k=1,m2
            if(lpmat(j,k))then
               tot1=0.0
               tot2=0.0
               do 30 i=1,n
                  bit1=(x1(j)-datx1(i))/h
                  bit2=(x2(k)-datx2(i))/h
                  change2=exp(-0.5*(bit1*bit1+bit2*bit2))*w(i)
                  change1=change2*y(i)
                  tot1=tot1+change1
                  tot2=tot2+change2
 30            continue
               zmat(j,k)=tot1/tot2
            else
               zmat(j,k)=0.0
            end if
 20      continue
 10   continue

      return
      end