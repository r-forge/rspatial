      subroutine kdesr9(h,x,y,nx,xmin,xmax,ymin,ymax)

c    .. calculates quartic edge-corrections on a rectangular polygon
c    .. at nx points (x,y)

c    .. inputs:
c    .. h is bandwidth
c    .. x is x-values of points at which to compute edge-correction
c    .. y is y-values of points at which to compute edge-correction
c    .. nx is length of x and y
c    .. xmin, xmax, ymin, ymax are as expected

c    .. output:
c    .. x contains edge-corrections at nx points

      implicit real (a-h, o-z)
      parameter (pi=3.141592653589793116)
      dimension x(nx),y(nx)

      sqrt8h=sqrt(8.0)*h

      do 10 i=1,nx
        ax=(xmin-x(i))/sqrt8h
        bx=(xmax-x(i))/sqrt8h
        ay=(ymin-y(i))/sqrt8h
        by=(ymax-y(i))/sqrt8h
        x(i)=qrt(-ax,-ay)+qrt(-ax,by)+qrt(bx,-ay)+qrt(bx,by)

10    continue

      return
      end


      real function qrt(x,y)
      implicit real (a-h, o-z)
      parameter (pi=3.141592653589793116)

      if((x.ge.(1.0)).and.(y.ge.(1.0))) then

        qrt= 0.25

      else if((x*x+y*y).le.(1.0)) then

        qrt= 3.0/pi*x*y*(1.0 -(2.0/3.0)*(x*x +y*y) +
     &  (2.0/9.0)*x*x*y*y +(x*x*x*x +y*y*y*y)/(5.0))

      else

        if(x.ge.(1.0)) then
          xbit=0.0
        else
          xbit= 0.25 -( asin(x) +x*sqrt(1.0 -x*x)*
     &    (8.0*x*x*x*x -26.0*x*x +33.0) /(15.0)) /(2.0*pi)
        end if

        if(y.ge.(1.0)) then
          ybit=0.0
        else
          ybit= 0.25 -( asin(y) +y*sqrt(1.0 -y*y)*
     &    (8.0*y*y*y*y -26.0*y*y +33.0) /(15.0)) /(2.0*pi)
        end if

        qrt= 0.25 -xbit -ybit

      end if

      return
      end