      subroutine kdesr6(h,rx,ry,nr,x,y,nx)

c    .. calculates spatial kernel density estimation with quartic kernel
c         at nx points (x,y)

c    .. inputs:
c    .. h is bandwidth
c    .. (rx,ry) is data
c    .. nr is no of data points
c    .. x is x-values of points at which to compute estimate
c    .. y is y-values of points at which to compute estimate
c    .. nx is length of x and y

c    .. output:
c    .. x contains density estimates at points

      implicit real (a-h, o-z)
      parameter (pi=3.141592653589793116)
      dimension rx(nr),ry(nr),x(nx),y(nx)

      con=(3/(8*pi*h*h))

      do 10 i=1,nx
        total=0.0
        do 20 k=1,nr
          sqdist=(x(i)-rx(k))**(2.0)+(y(i)-ry(k))**(2.0)
          dsq=sqdist/(8*h*h)
          change=0
          if( dsq .lt. 1.0 ) then
            bit=1.0-dsq
            change=bit*bit
          end if
          total=total+change
20      continue
        x(i)=con*total/real(nr)
10    continue

      return
      end