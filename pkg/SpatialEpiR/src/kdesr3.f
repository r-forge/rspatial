      subroutine kdesr3(h,rx,ry,nr,x,y,nx)

c    .. calculates spatial kernel density estimation with normal kernel
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

      pih=(2.0*pi*(h**2.0))**(-1.0)

      do 10 i=1,nx
        total=0.0
        do 20 k=1,nr
          sqdist=(x(i)-rx(k))**(2.0)+(y(i)-ry(k))**(2.0)
          change=exp(-0.5*sqdist/(h**2.0) )
          total=total+change
20      continue
        x(i)=pih*total/real(nr)
10    continue

      return
      end