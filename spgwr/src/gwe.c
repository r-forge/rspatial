/*  Copyright by Roger Bivand (C) 2003 (with thanks to Chris Brunsdon
 *  for access to his Fortran code)
 */
#include <R.h>
#include <Rdefines.h>
#include <Rmath.h>
#include <R_ext/Applic.h>

void gw_dists(double *u, double *v, double *uout, double *vout, 
		int *n, double *dists);

void gw_adapt(double *u, double *v, double *uout, double *vout, int *n1, 
		int *n2, double *bw, double *qin, double *d) 
{
	int N1 = *n1, N2 = *n2, i, index;
	double q = *qin;
	double uo[1], vo[1];
	
	index = floor((N1-1)*q + 0.5); /* + 1 */

	for (i=0; i<N2; i++) {
	    	uo[0] = uout[i];
	    	vo[0] = vout[i];
		gw_dists(u, v, uo, vo, n1, d);

		R_rsort(d, N1);
		bw[i] = d[index];
	}
}

void gw_dists(double *u, double *v, double *uout, double *vout, 
		int *n, double *dists)
{
	int N = *n, j;
		
	for (j=0; j<N; j++) 
		dists[j] = pythag((u[j]-uout[0]), (v[j]-vout[0]));
}


