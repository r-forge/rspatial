/* matfunc - A collection of matrix functions */

#include <stdio.h>
#include <math.h>
#include "smacc.h"

#define TINY 1.0e-20     /* used in the LU decomposition function ludcmp */

/* LU decomposition from NR in C p. 46                                   */
/* NOTE: in this and the following functions taken from NR, the sums run
   from one instead of zero. This is caused by the way they define their
   vectors and matrices. The result being in our version: all the [i-1]'s
   in the body of the program. */
int ludcmp(double **a, int n, int *indx, double *d) {

    int i, imax, j, k;
    double big, dum, sum, temp;

    double *vv;

    vv=dvector(n);

    *d = 1.0;
    for (i=1; i<=n; i++) {
        big = 0.0;
        for (j=1; j<=n; j++)
            if ((temp=fabs(a[i-1][j-1])) > big) big=temp;
            if (big == 0.0) {
                printf("ludcmp: Singular matrix\n");
                free_dvector(vv);
                return(-1);
            }
            vv[i-1] = 1.0/big;
    }
    for (j=1; j<=n; j++) {
        for (i=1; i<j; i++) {
            sum = a[i-1][j-1];
            for (k=1; k<i; k++)
                sum -= a[i-1][k-1]*a[k-1][j-1];
            a[i-1][j-1] = sum;
        }
        big = 0.0;
        for (i=j; i<=n; i++) {
            sum = a[i-1][j-1];
            for (k=1; k<j; k++)
                sum -= a[i-1][k-1]*a[k-1][j-1];
            a[i-1][j-1] = sum;
            if ( (dum=vv[i-1]*fabs(sum)) >= big) {
                big = dum;
                imax = i;
            }
        }
        if (j != imax) {
            for (k=1; k<=n; k++) {
                dum = a[imax-1][k-1];
                a[imax-1][k-1] = a[j-1][k-1];
                a[j-1][k-1] = dum;
            }
            *d = -(*d);
            vv[imax-1] = vv[j-1];
        }
        indx[j-1] = imax;
        if (a[j-1][j-1] == 0.0) a[j-1][j-1] = TINY;
        if (j != n) {
            dum = 1.0/(a[j-1][j-1]);
            for (i=j+1; i<=n; i++) a[i-1][j-1] *= dum;
        }
    }
    free_dvector(vv);
    return(0);
}


/* Routine for back & forward substitution after a LU decomposition, NR p. 47 */
void lubksb(double **a, int n, int *indx, double *b) {

    int i, ii=0, ip, j;
    double sum;

    for (i=1; i<=n; i++) {
        ip = indx[i-1];
        sum = b[ip-1];
        b[ip-1] = b[i-1];
        if (ii)
            for (j=ii; j<=i-1; j++) sum -= a[i-1][j-1]*b[j-1];
        else if (sum) ii = i;
            b[i-1] = sum;
    }
    for (i=n; i>=1; i--) {
        sum = b[i-1];
        for (j=i+1; j<=n; j++) sum -= a[i-1][j-1]*b[j-1];
        b[i-1] = sum/(a[i-1][i-1]);
    }
}


/* Matrix inversion using ludcmp and lubksb, NR p.48 */
/* The inverse of a is returned in y, and a will have been destroyed */
void matinv(double **a, int n, double **y) {

    int i, j, *indx;
    double d, *col;

    indx = ivector(n);
    col  = dvector(n);

    ludcmp(a,n,indx,&d);
    for (j=0; j<n; j++) {
         for (i=0; i<n; i++) col[i]=0.0;
         col[j] = 1.0;
         lubksb(a,n,indx,col);
         for (i=0; i<n; i++) y[i][j]=col[i];
    }

    free_ivector(indx);
    free_dvector(col);
    return;
}


/* Makes a copy of matrix a with dimensions [nrow][ncol] to matrix b  */
void matcopy(double **a, int nrow, int ncol, double **b) {

    int i, j;

    for (i=0; i<nrow; i++)
        for (j=0; j<ncol; j++)
            b[i][j] = a[i][j];
    return;
}

/* Makes a copy of vector a with lenght n to vector b */
void veccopy(double *a, int n, double *b) {

    int i;

    for (i=0; i<n; i++) b[i]=a[i];
    return;
}

/* Makes a copy of a long int vector a with lenght n to a long int vector b */
void liveccopy(long int *a, int n, long int *b) {

    int i;

    for (i=0; i<n; i++) b[i]=a[i];
    return;
}


/* Copy the rows a[frow..frow+no-1][ncol] to matrix b[0..no-1][ncol]  */
void rowcopy(double **a, int frow, int no, int ncol, double **b) {

    int i, j;

    for (i=frow; i<frow+no; i++)
        for (j=0; j<ncol; j++)
            b[i-frow][j] = a[i][j];
    return;
}


/* Inserts matrix a[nrow][ncol] into b at position b[baserow][basecol],
   i.e. b[baserow][basecol] = a[0][0], ... b[baserow+nrow-1][basecol+ncol-1] = a[nrow-1][ncol-1] */
static void matinsert(double **a, double **b, int nrow, int ncol, int baserow, int basecol) {

    int i, j;

    for (i=0; i<nrow; i++)
        for (j=0; j<ncol; j++)
            b[baserow+i][basecol+j]=a[i][j];
}


/* Inserts vector a[nrow] into vector b at position b[baserow],
   i.e. b[baserow] = a[0], ... b[baserow+nrow-1] = a[nrow-1] */
static void vecinsert(double *a, double *b, int nrow, int baserow) {

    int i;

    for (i=0; i<nrow; i++)
        b[baserow+i] = a[i];
}


/* Matrix multiplication of a[nrowa][ncol] and b[ncol][ncolb] to matrix
   c[nrowa][ncolb] */
void matmult(double **a, double **b, int nrowa, int ncol, int ncolb, double **c) {

    int i, j, k;
    double sum;

    for (i=0; i<nrowa; i++)
        for (j=0; j<ncolb; j++) {
            sum = 0.0;
            for (k=0; k<ncol; k++) sum += a[i][k]*b[k][j];
            c[i][j] = sum;
        }
    return;
}


/* Matrix multiplication of a[nrowa][ncol], diagonal matrix d[ncol][ncol] and
   b[ncol][ncolb] to matrix c[nrowa][ncolb], c=adb */
static void matdmult(double **a, double **d, double **b,
                                int nrowa, int ncol, int ncolb, double **c) {

    int i, j, k;
    double sum;

    for (i=0; i<nrowa; i++)
        for (j=0; j<ncolb; j++) {
            sum = 0.0;
            for (k=0; k<ncol; k++) sum += a[i][k]*d[k][k]*b[k][j];
            c[i][j] = sum;
        }
    return;
}


/* Multiplication of matrix a[nrow][ncol] with vector b[ncol] to vector
   c[nrow], c=ab */
static void matvecmult(double **a, double *b, int nrow, int ncol, double *c) {

    int i, j;
    double sum;

    for (i=0; i<nrow; i++) {
            sum = 0.0;
            for (j=0; j<ncol; j++) sum += a[i][j]*b[j];
        c[i] = sum;
        }
    return;
}


/* Transposed matrix multiplication of (a[nrow][ncola])' and b[nrow][ncolb]
   to matrix c[ncola][ncolb]; c=a'b*/
void mattransmult(double **a, double **b, int nrow, int ncola, int ncolb, double **c) {

    int i, j, k;
    double sum;

    for (i=0; i<ncola; i++)
        for (j=0; j<ncolb; j++) {
            sum = 0.0;
            for (k=0; k<nrow; k++) sum += a[k][i]*b[k][j];
            c[i][j] = sum;
        }
    return;
}


/* Transposed matrix multiplication of (a[nrow][ncola])', diagonal matrix
   d[nrow][nrow] and b[nrow][ncolb] to matrix c[ncola][ncolb], c=a'db */
static void mattransdmult(double **a, double **d, double **b,
                       int nrow, int ncola, int ncolb, double **c) {

    int i, j, k;
    double sum;

    for (i=0; i<ncola; i++)
        for (j=0; j<ncolb; j++) {
                sum = 0.0;
                for (k=0; k<nrow; k++) sum += a[k][i]*d[k][k]*b[k][j];
                c[i][j] = sum;
            }
    return;
}


/* Matrix multiplication of a[nrowa][ncol], diagonal matrix
   d[ncol][ncol] and (b[nrowb][ncol])' to matrix c[nrowa][nrowb], c=adb' */
static void mat2transdmult(double **a, double **d, double **b,
                    int nrowa, int ncol, int nrowb, double **c) {

    int i, j, k;
    double sum;

    for (i=0; i<nrowa; i++)
        for (j=0; j<nrowb; j++) {
                sum = 0.0;
                for (k=0; k<ncol; k++) sum += a[i][k]*d[k][k]*b[j][k];
                c[i][j] = sum;
            }
    return;
}


/* Transposed matrix multiplication of (a[nrow][ncola])', diagonal matrix
   d[nrow][nrow] and vector b[nrow] to vector c[ncola], c=a'db */
static void mattransdvecmult(double **a, double **d, double *b,
                       int nrow, int ncola, double *c) {

    int i, j;
    double sum;

    for (i=0; i<ncola; i++) {
        sum = 0.0;
        for (j=0; j<nrow; j++) sum += a[j][i]*d[j][j]*b[j];
        c[i] = sum;
    }
    return;
}


/* Addition of two vectors a[nrow] and b[nrow] to c[nrow] */
static void vecadd(double *a, double *b, int nrow, double *c) {

    int i;

    for (i=0; i<nrow; i++) c[i] = a[i] + b[i];
    return;
}


/* Subtraction of two vectors a[nrow] and b[nrow] to c[nrow] */
static void vecsub(double *a, double *b, int nrow, double *c) {

    int i;

    for (i=0; i<nrow; i++) c[i] = a[i] - b[i];
    return;
}
