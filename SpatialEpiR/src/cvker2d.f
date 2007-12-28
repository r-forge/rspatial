      subroutine cvker2d(h,x1,x2,y,w,n,cv)

      implicit   real (a-h, o-z)
      dimension  y(n),w(n),x1(n),x2(n)

      cvtot=0.0

      do 10 j = 1,n
         tot1 = 0.0
         tot2 = 0.0

         do 20 i = 1,n
            bit1 = (x1(j)-x1(i))/h
            bit2 = (x2(j)-x2(i))/h
            change2 = exp(-0.5*(bit1*bit1+bit2*bit2))*w(i)
            change1 = change2*y(i)
            tot1 = tot1+change1
            tot2 = tot2+change2
 20      continue

         thing = y(j) - (tot1-w(j)*y(j))/(tot2-w(j))

         cvtot = cvtot + w(j)*thing*thing

 10   continue

      cv = cvtot/real(n)

      return
      end