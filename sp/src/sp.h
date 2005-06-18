#ifndef R_SP_H
#define R_SP_H

#include <R.h>
#include <Rinternals.h>
#include <Rmath.h>

/* from insiders.c 

int pipbb(double pt1, double pt2, double *bbs);
int between(double x, double low, double up); 
SEXP insiders(SEXP n1, SEXP bbs); */

/* from pip.c */

#ifndef MIN
# define MIN(a,b) ((a)>(b)?(b):(a))
#endif
#ifndef MAX
# define MAX(a,b) ((a)>(b)?(a):(b))
#endif

/* polygon structs: */
typedef struct {
	double		x, y;
} PLOT_POINT;

typedef struct {
	PLOT_POINT	min, max;
} MBR;

typedef struct polygon {
	MBR mbr;
	int lines;
	PLOT_POINT	*p;
    int close; /* 1 - is closed polygon */
} POLYGON;

void setup_poly_minmax(POLYGON *pl);
char InPoly(PLOT_POINT q, POLYGON *Poly);
SEXP R_point_in_polygon_sp(SEXP px, SEXP py, SEXP polx, SEXP poly);
void spRFindCG( int *n, double *x, double *y, double *xc, double *yc, 
		double *area );
void sp_gcdist(double *lon1, double *lon2, double *lat1, double *lat2, 
		double *dist);
void sp_dists(double *u, double *v, double *uout, double *vout, 
		int *n, double *dists, int *lonlat);


#endif

