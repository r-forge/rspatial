      subroutine ker2d(h,datx1,datx2,y,w,n,x1,x2,yans,m,df)

      implicit   real (a-h, o-z)
      dimension  datx1(n),datx2(n),y(n),w(n),x1(m),x2(m),yans(m)

      do 10 j=1,m
         tot1=0.0
         tot2=0.0

         do 20 i=1,n
            bit1=(x1(j)-datx1(i))/h
            bit2=(x2(j)-datx2(i))/h
            change2=exp(-0.5*(bit1*bit1+bit2*bit2))*w(i)
            change1=change2*y(i)
            tot1=tot1+change1
            tot2=tot2+change2
 20      continue

         yans(j)=tot1/tot2
         df=df+w(i)/tot2

 10   continue

      return
      end