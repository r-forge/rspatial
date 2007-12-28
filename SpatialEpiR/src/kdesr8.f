      subroutine kdesr8(h,x,y,nx,ny,lpmat1,px,py,np,lpmat2,radii,
     +                  m,npts,zmat)

c    .. calculates part of edge-corrections for spatial kernel density
c       estimation at nx * ny points on grid (x,y) as part of
c       Splus function ksedge
c       (grid) points on boundary are treated inconsistently by inout,
c       so avoid this situation!

c    .. inputs:
c    .. h is bandwidth
c    .. x is x-values of points at which to compute edge-correction
c    .. y is y-values of points at which to compute edge-correction
c    .. nx is length of x
c    .. ny is length of y
c    .. lpmat1 is logical nx by ny matrix : T if point(x,y) in poly
c    .. px, py and np form the polygon
c    .. lpmat2 is logical nx by ny matrix : T if point(x,y) in inpoly
c    .. radii is the radii of the annuli
c    .. m is no of annulii
c    .. npts is no of points in each annulus

c    .. output:
c    .. zmat contains edge-corrections at points (x,y) on grid

      implicit real (a-h, o-z)
      logical lpmat1,lpmat2
      parameter (pi=3.141592653589793116)
      dimension x(nx),y(ny),lpmat1(nx,ny),px(np),py(np),lpmat2(nx,ny),
     +          radii(m),zmat(nx,ny)

      call ranstart()

      do 10 i=1,nx
        do 20 j=1,ny
          if (lpmat1(i,j)) then
            z=1.0
            if(.not.lpmat2(i,j)) then
              do 30 k=1,m
                bit=rans(1)
                ntot=0
                do 40 nn=1, npts
                  theta=((real(nn)-bit)/real(npts))*2.0*pi
                  cosk=cos(theta)
                  sink=sin(theta)
                  ringx=x(i)+radii(k)*cosk
                  ringy=y(j)+radii(k)*sink
                  lptin=imp(ringx,ringy,px,py,np)
                  if (lptin.ne.0) then
                    ntot=ntot+1
                  end if
40              continue
                if(ntot .eq. npts) then
                  goto 50
                else
                  z=z-(real(npts)-real(ntot))/real(npts*m)
                end if
30            continue
            end if
          else
            z=0.0
          end if
50      zmat(i,j)=z
20      continue
10    continue

      call ranstop()

      return
      end


      function rans(idummy)
      implicit real (a-h,o-z)
      real*8 x
      call dranget(x)
      rans=sngl(x)
      return
      end