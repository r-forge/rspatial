      subroutine kdesr10(h,x,y,nx,ny,xmin,xmax,ymin,ymax,zmat)

c    .. calculates quartic edge-corrections on a rectangular polygon
c    .. at nx * ny points on grid (x,y)

c    .. inputs:
c    .. h is bandwidth
c    .. x is x-values of points at which to compute edge-correction
c    .. y is y-values of points at which to compute edge-correction
c    .. nx is length of x
c    .. ny is length of y
c    .. xmin, xmax, ymin, ymax are as expected

c    .. output:
c    .. zmat contains edge-corrections at nx * ny points on grid

      implicit real (a-h, o-z)
      parameter (pi=3.141592653589793116)
      dimension x(nx),y(ny),zmat(nx,ny)

      sqrt8h=2.0*sqrt(2.0)*h

      do 10 i=1,nx
        do 20 j=1,ny
          ax=(xmin-x(i))/sqrt8h
          bx=(xmax-x(i))/sqrt8h
          ay=(ymin-y(j))/sqrt8h
          by=(ymax-y(j))/sqrt8h
          zmat(i,j)=qrt(-ax,-ay)+qrt(-ax,by)+qrt(bx,-ay)+qrt(bx,by)
20      continue
10    continue

      return
      end