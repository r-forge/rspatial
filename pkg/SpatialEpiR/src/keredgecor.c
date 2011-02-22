/* keredgecor.c */
/* Performs (approximative) kernel density edge corrections */

#include "smacc.h"
#include <math.h>
#include <stdio.h>

#define PI 3.141592653589793116

/* -------------------------------------------------------------------
   ----------------- Help routines for keredgecor --------------------
   -------------------------------------------------------------------
*/

/* quadrant id's, incremental angles, accumulated angle values */
typedef short quadrant_type;

/* determine the quadrant of a polygon point relative to the test point */
#define quadrant(xv,yv, x, y)  ( (xv > x) ? ((yv > y) ? 0 : 3) : ( (yv > y) ? 1 : 2) )

/* determine x intercept of a polygon edge with a horizontal line at the y value of the test point */
#define x_intercept(xv, yv, xnv, ynv,  yy)  (xnv - ( (ynv - yy) * ((xv - xnv) / (yv - ynv)) ) )

/* adjust delta */
#define adjust_delta(delta, xv, yv, xnv, ynv, xx, yy) switch (delta) { /* make quadrant deltas wrap around */ case  3:    delta = -1; break; case -3:    delta =  1; break;  /* check if went around point cw or ccw */ case  2: case -2: if (x_intercept(xv, yv, xnv, ynv, yy) > xx)  delta =  - (delta); break; }

/* determine if a test point is inside of or outside of a polygon                 */
/* polygon is "poly", test point is at "x","y"                                    */
/* 1 =  inside, 0 = outside                                                       */

/* Routine taken from the article "An Incremental Angle Point in Polygon Test"    */
/* by Kevin Weiler, kjw@autodesk.com in "Graphics Gems IV", Academic Press, 1994  */


static int point_in_poly(double* xcor, double* ycor, long int ncor, double x, double y)
{

  double xv, yv, xnv, ynv;
  int i;
  quadrant_type quad, next_quad, delta, angle;

  /* initialize */
  xv = xcor[0]; yv = ycor[0];

  quad = quadrant(xv,yv, x, y);
  angle = 0;

   /* loop on all vertices of polygon */
  for (i=1; i<ncor; i++) {
    xnv = xcor[i]; ynv = ycor[i];
                /* calculate quadrant and delta from last quadrant */
    next_quad = quadrant(xnv,ynv, x, y);
    delta = next_quad - quad;
    adjust_delta(delta,xv,yv,xnv,ynv,x,y);
    /* add delta to total angle sum */
    angle = angle + delta;
    /* increment for next step */
    quad = next_quad;
    xv = xnv; yv = ynv;
    }
  /* complete 360 degrees (angle of + 4 or -4 ) means inside */
  if ((angle == +4) || (angle == -4)) return 1; else return 0;
}

/* -------------------------------------------------------------------
   -------------------------------------------------------------------
*/


/* This function can be called from Splus */

/* Calculates a vector of edge corrections for the vector of points (x,y) with respect to the polygon
   (polyx,polyy) for either a normal or a quartic kernel

 h        : bandwith
 polyx    : x-coordinates of polygon
 polyy    : y-coordinates of polygon
 npoly    : no of points in polygon + 1 (because the first point is repeated)
 x        : x-coordinates of the points for which the edge correction is calculated
 y        : y-coordinates of the points for which the edge correction is calculated
 npoints  : no of points
 Ikernel  : 1 - normal kernel; 2 - quartic kernel
 rings    : no of rings used (see Julia Kelsall notes)
 denspts  : no of points on each ring
 edgevec  : the calculated edge corrections
 seed     : seed for random number generator
*/


void keredgecor (double* h, double* polyx, double* polyy, long int* npoly, double* x, double* y, long int* npoints,
                 long int* Ikernel, long int* rings, long int* denspts, double* edgevec, long int* seed) {

  int i, k, m, ntot;
  double *r, ranoff, theta, ringx, ringy, dpts;

  r    = dvector(*rings);
  dpts = (double) *denspts;
  /* Normal kernel */
  if (*Ikernel==1) for (m=0; m < *rings; m++) r[m] = *h * sqrt(-2* log((m + 0.5)/ *rings));
  /* Quartic kernel */
  if (*Ikernel==2) for (m=0; m < *rings; m++) r[m] = *h * sqrt(8 * ( 1 - exp(log( (m+ 0.5)/ *rings)/ 3 ) ) );

  /* Initialise the random number generator: */
  initran1(*seed);

  for (i=0; i< *npoints; i++) {

    if (!point_in_poly(polyx,polyy,*npoly,x[i],y[i])) edgevec[i]=-1.0; // -1 if point not in polygon
    else {
      edgevec[i]=1.0;
      for (m=0; m<*rings; m++) {  // m=0 is the outermost ring
        ranoff=ran1();
        ntot=0;
        for (k=0; k<*denspts; k++) {
          theta=( ((double) k) - ranoff)/dpts*2.0*PI;
          ringx=x[i]+r[m]*cos(theta);
          ringy=y[i]+r[m]*sin(theta);
          if (point_in_poly(polyx,polyy,*npoly,ringx,ringy)) ntot++;
        }
        if (ntot == *denspts) break;
        else edgevec[i]-=(dpts - ((double) ntot))/((double) ((*denspts)*(*rings)));
      }
    }
  }
  free_dvector(r);
}
