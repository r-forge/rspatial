      subroutine kdesr7(h,x,y,nx,lpin1,px,py,np,lpin2,radii,m,npts)

c    .. calculates part of edge-corrections for spatial kernel density
c       estimation at nx points (x,y) as part of
c       Splus function ksedge
c       (grid) points on boundary are treated inconsistently by inout,
c       so avoid this situation!

c    .. inputs:
c    .. h is bandwidth
c    .. x is x-values of points at which to compute edge-correction
c    .. y is y-values of points at which to compute edge-correction
c    .. nx is length of x and y
c    .. lpin1 is logical vector of length nx : T if point(x,y) in poly
c    .. px, py and np form the polygon
c    .. lpin2 is logical vector of length nx : T if point(x,y) in inpoly
c    .. radii is the radii of the annuli
c    .. m is no of rings
c    .. npts is no of points in each annulus

c    .. output:
c    .. x contains edge-corrections at points (x,y)

      implicit real (a-h, o-z)
      logical lpin1,lpin2
      parameter (pi=3.141592653589793116)
      dimension x(nx),y(nx),lpin1(nx),px(np),py(np),
     &          lpin2(nx),radii(m)

      call ranstart()

      do 10 i=1,nx
        if (lpin1(i)) then
          z=1.0
          if(.not.lpin2(i)) then
            do 20 j=1,m
              bit=rans(1)
              ntot=0
              do 30 k=1, npts
                theta=((real(k)-bit)/real(npts))*2.0*pi
                cosk=cos(theta)
                sink=sin(theta)
                ringx=x(i)+radii(j)*cosk
                ringy=y(i)+radii(j)*sink
                lptin=imp(ringx,ringy,px,py,np)
                if (lptin.ne.0) then
                  ntot=ntot+1
                end if
30            continue
              if(ntot .eq. npts) then
                goto 40
              else
                z=z-(real(npts)-real(ntot))/real(npts*m)
              end if
20          continue
          end if
        else
          z=0.0
        end if
40    x(i)=z
10    continue

      call ranstop()

      return
      end