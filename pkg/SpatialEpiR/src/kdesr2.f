
      subroutine kdesr2(h,rx,ry,nr,x,nx,y,ny,zmat)

c    .. calculates spatial kernel density estimation with normal kernel
c         at nx*ny points on grid (x,y)

c    .. inputs:
c    .. h is bandwidth
c    .. (rx,ry) is data
c    .. nr is no of data points
c    .. x is x-values of grid on which to compute estimate
c    .. y is y-values of grid on which to compute estimate
c    .. nx is length of x
c    .. ny is length of y

c    .. output:
c    .. zmat contains density estimates at grid points

      implicit real (a-h, o-z)
      parameter (pi=3.141592653589793116)
      dimension rx(nr),ry(nr),x(nx),y(ny),zmat(nx,ny)

      pih=(2.0*pi*(h**2.0))**(-1.0)

      do 10 i=1,nx
        do 20 j=1,ny
          total=0.0
          do 30 k=1,nr
            sqdist=(x(i)-rx(k))**(2.0)+(y(j)-ry(k))**(2.0)
            change=exp(-0.5*sqdist/(h**2.0) )
            total=total+change
30        continue
          zmat(i,j)=pih*total/real(nr)
20      continue
10    continue

      return
      end