/* The Newton Rapson search rutine from Numerical Recipes in C p. 385-388  */

#include <stdio.h>
#include <math.h>
#include "smacc.h"

#define ALF 1.0e-4       /* used in the line search function lnsrch */
#define TOLX 1.0e-9      /* used in lnsrch, newt and dfpmin */
#define TOLF 1.0e-6      /* used in newt */
#define TOLMIN 1.0e-8
#define STPMX 2.0        /* used in newt */
#define MAXITS 200       /* the following four are used in the function newt a.o. */
#define FDJACEPS 1.0e-4       /* used in the function fdjac */

#define ITMAX 200        /* used in dfpmin */
#define EPS 3.0e-8       /* used in dfpmin */



/* Used to communicate with fmin when doing Newton Rapson */
static double *fvec;
static void (*nrfuncv)(int n, double *v, double *f);

/* This is used in newt */
static double fmin_EpiR(int n, double *x) {

    int i;
    double sum;

    (*nrfuncv)(n, x, fvec);
    sum = 0.0;
    for (i=1; i<=n; i++) sum += SQR(fvec[i-1]);
    return(0.5*sum);
}


/* Numeric differentiation of vector function */
static void fdjac(int n, double *x, double *fvec,
           double **df, void (*vecfunc)(int, double [], double [])) {

    int i, j;
    double h, temp, *f;

    f=dvector(n);

    for (j=1; j<=n; j++) {
        temp = x[j-1];
        h = FDJACEPS*fabs(temp);
        if (h == 0.0) h = FDJACEPS;
        x[j-1] = temp + h;
        h = x[j-1] - temp;     /* Trick to reduce finite precision error */
        (*vecfunc)(n,x,f);
        x[j-1] = temp;
        for (i=1; i<=n; i++) df[i-1][j-1] = (f[i-1] - fvec[i-1])/h;
    }
    free_dvector(f);
    return;
}

/* The following is used in the Newton Rapson routine newt. */
static void lnsrch(int n, double *xold, double fold, double *g, double *p, double *x,
            double *f, double stpmax, int *check, double (*func)(int, double *)) {

    int i;
    double a, alam, alam2, alamin, b, disc, f2, fold2, rhs1, rhs2;
    double slope, sum, temp, test, tmplam;

    *check = 0;
    sum = 0.0;
    for (i=1; i<=n; i++) sum += p[i-1]*p[i-1];

    sum = sqrt(sum);
    if (sum > stpmax)
        for (i=1; i<=n; i++) p[i-1] *= stpmax/sum;
    slope = 0.0;
    for (i=1; i<=n; i++) slope += g[i-1]*p[i-1];
    test = 0.0;
    for (i=1; i<=n; i++) {
        temp = fabs(p[i-1])/FMAX(fabs(xold[i-1]),1.0);
        if (temp > test) test = temp;
    }
    alamin = TOLX/test;
    alam = 1.0;
    for (;;) {
        for (i=1; i<=n; i++) x[i-1] = xold[i-1] + alam*p[i-1];
        *f = (*func)(n,x);

        if (alam < alamin) {
            for (i=1; i<=n; i++) x[i-1] = xold[i-1];
            *check = 1;
            return;
        } else if (*f <= fold + ALF*alam*slope) {
            return;
        }
        else {
            if (alam == 1.0) {
                tmplam = -slope/(2.0*(*f - fold - slope));
            }
            else {
                rhs1 = *f - fold - alam*slope;
                rhs2 = f2 - fold2 - alam2*slope;
                a = (rhs1/(alam*alam) - rhs2/(alam2*alam2))/(alam - alam2);
                b = (-alam2*rhs1/(alam*alam) + alam*rhs2/(alam2*alam2))/(alam-alam2);
                if (a == 0.0) tmplam = -slope/(2.0*b);
                else {
                    disc = b*b - 3.0*a*slope;
                    if (disc < 0.0) { printf("Roundoff problem in lnsrch\n"); return; }
                    else tmplam = (-b + sqrt(disc))/(3.0*a);
                }
                if (tmplam > 0.5*alam) tmplam = 0.5*alam;
            }
        }
        alam2 = alam;
        f2 = *f;
        fold2 = fold;
        alam = FMAX(tmplam, 0.1*alam);
    }
}

/* Newton Rapson minimisation of function vecfunc (using numerical differentiation of vecfunc) */
/* The routine uses the function lnrsch from above on the function fmin which uses the global variable fvec */
void newt(double *x, int dimx, int *check, void (*vecfunc)(int, double [], double [])) {

    int i, its, j;
    int *indx;
    double d, den, f, fold, stpmax, sum, temp, test;
    double **fjac, *g, *p, *xold;

    fvec = dvector(dimx);        /* Allocates the global variable fvec */
    indx = ivector(dimx);
    fjac = dmatrix(dimx,dimx);
    g    = dvector(dimx);
    p    = dvector(dimx);
    xold = dvector(dimx);

    nrfuncv = vecfunc;
    f = fmin_EpiR(dimx, x);           /* the global variable fvec is also computed by this call */

    test = 0.0;
    for (i=1; i<=dimx; i++)
        if (fabs(fvec[i-1]) > test) test = fabs(fvec[i-1]);
    if (test < 0.01*TOLF) {
        *check = 0;
        free_dvector(fvec);
        free_ivector(indx);
        free_dmatrix(fjac);
        free_dvector(g);
        free_dvector(p);
        free_dvector(xold);
        return;
    }

    sum = 0.0;
    for (i=1; i<=dimx; i++) sum += SQR(x[i-1]);

    stpmax = STPMX*FMAX(sqrt(sum),(double) dimx);
    for (its=1; its<=MAXITS; its ++) {

        /* Numeric differentiation:  */
        fdjac(dimx,x,fvec,fjac,vecfunc);

        for (i=1; i<=dimx; i++) {
            sum = 0.0;
            for (j=1; j<=dimx; j++) { sum += fjac[j-1][i-1]*fvec[j-1]; }
            g[i-1] = sum;
        }

        for (i=1; i<=dimx; i++) xold[i-1] = x[i-1];
        fold = f;
        for (i=1; i<=dimx; i++) p[i-1] = -fvec[i-1];

        ludcmp(fjac,dimx,indx,&d);
        lubksb(fjac,dimx,indx,p);
        lnsrch(dimx,xold,fold,g,p,x,&f,stpmax,check,fmin_EpiR);

        test = 0.0;
        for (i=1; i<=dimx; i++)
            if (fabs(fvec[i-1]) > test) test = fabs(fvec[i-1]);
        if (test < TOLF) {
            *check = 0;
            free_dvector(fvec);
            free_ivector(indx);
            free_dmatrix(fjac);
            free_dvector(g);
            free_dvector(p);
            free_dvector(xold);
            return;
        }
        if (*check) {
            test = 0.0;
            den = FMAX(f,0.5*dimx);
            for (i=1; i<=dimx; i++) {
                temp = fabs(g[i-1])*FMAX(fabs(x[i-1]),1.0)/den;
                if (temp > test) test = temp;
            }
            *check = (test < TOLMIN ? 1 : 0);

            free_dvector(fvec);
            free_ivector(indx);
            free_dmatrix(fjac);
            free_dvector(g);
            free_dvector(p);
            free_dvector(xold);
            return;
        }
        test = 0.0;
        for (i=1; i<=dimx; i++) {
            temp = (fabs(x[i-1] - xold[i-1]))/FMAX(fabs(x[i-1]),1.0);
            if (temp > test) test = temp;
        }
        if (test < TOLX) {
            free_dvector(fvec);
            free_ivector(indx);
            free_dmatrix(fjac);
            free_dvector(g);
            free_dvector(p);
            free_dvector(xold);
            return;
        }
    }
    printf("MAXITS exceeded in newt\n");
}

/* Newton Rapson root finding of function vecfunc using the analytic derivative vecfuncdif of vecfunc */
/* The routine uses the function lnrsch from above */
void newt_an(double *x, int dimx, int *check, void (*vecfunc)(int, double *, double *),
             void (*vecfuncdif)(int, double *, double **)) {

    int i, its, j;
    int *indx;
    double d, den, f, fold, stpmax, sum, temp, test;
    double **fjac, *g, *p, *xold;

    fvec = dvector(dimx);        /* Allocates the global variable fvec */
    indx = ivector(dimx);
    fjac = dmatrix(dimx,dimx);
    g    = dvector(dimx);
    p    = dvector(dimx);
    xold = dvector(dimx);

    nrfuncv = vecfunc;
    f = fmin_EpiR(dimx, x);           /* the global variable fvec is also computed by this call */

    test = 0.0;
    for (i=1; i<=dimx; i++)
        if (fabs(fvec[i-1]) > test) test = fabs(fvec[i-1]);
    if (test < 0.01*TOLF) {
        *check = 0;
        free_dvector(fvec);
        free_ivector(indx);
        free_dmatrix(fjac);
        free_dvector(g);
        free_dvector(p);
        free_dvector(xold);
        return;
    }

    sum = 0.0;
    for (i=1; i<=dimx; i++) sum += SQR(x[i-1]);

    stpmax = STPMX*FMAX(sqrt(sum),(double) dimx);
    for (its=1; its<=MAXITS; its ++) {

        /* Analytic differentiation:  */
        (*vecfuncdif)(dimx,x,fjac);

        for (i=1; i<=dimx; i++) {
            sum = 0.0;
            for (j=1; j<=dimx; j++) { sum += fjac[j-1][i-1]*fvec[j-1]; }
            g[i-1] = sum;
        }

        for (i=1; i<=dimx; i++) xold[i-1] = x[i-1];
        fold = f;
        for (i=1; i<=dimx; i++) p[i-1] = -fvec[i-1];

        ludcmp(fjac,dimx,indx,&d);
        lubksb(fjac,dimx,indx,p);
        lnsrch(dimx,xold,fold,g,p,x,&f,stpmax,check,fmin_EpiR);

        test = 0.0;
        for (i=1; i<=dimx; i++)
            if (fabs(fvec[i-1]) > test) test = fabs(fvec[i-1]);
        if (test < TOLF) {
            *check = 0;
            free_dvector(fvec);
            free_ivector(indx);
            free_dmatrix(fjac);
            free_dvector(g);
            free_dvector(p);
            free_dvector(xold);
            return;
        }
        if (*check) {
            test = 0.0;
            den = FMAX(f,0.5*dimx);
            for (i=1; i<=dimx; i++) {
                temp = fabs(g[i-1])*FMAX(fabs(x[i-1]),1.0)/den;
                if (temp > test) test = temp;
            }
            *check = (test < TOLMIN ? 1 : 0);

            free_dvector(fvec);
            free_ivector(indx);
            free_dmatrix(fjac);
            free_dvector(g);
            free_dvector(p);
            free_dvector(xold);
            return;
        }
        test = 0.0;
        for (i=1; i<=dimx; i++) {
            temp = (fabs(x[i-1] - xold[i-1]))/FMAX(fabs(x[i-1]),1.0);
            if (temp > test) test = temp;
        }
        if (test < TOLX) {
            free_dvector(fvec);
            free_ivector(indx);
            free_dmatrix(fjac);
            free_dvector(g);
            free_dvector(p);
            free_dvector(xold);
            return;
        }
    }
    printf("MAXITS exceeded in newt_an\n");
}

/* n is dim of the variable p. p must contain an initial guess */
void dfpmin(double *p, int n, double gtol, int *iter, double *fret,
            double (*func)(int ,double *), void (*dfunc)(int, double *,double *))

{

  int check, i, its, j;
  double den, fac, fad, fae, fp, stpmax, sum, sumdg, sumxi, temp, test;
  double *dg, *g, *hdg, *pnew, *xi;
  double **hessin;

  sum = 0.0;

  dg     = dvector(n);
  g      = dvector(n);
  hdg    = dvector(n);
  hessin = dmatrix(n,n);
  pnew   = dvector(n);
  xi     = dvector(n);

  fp     = (*func)(n,p);

  for (i=1; i<=n; i++) {
    for (j=1; j<=n; j++) hessin[i-1][j-1] = 0.0;
    hessin[i-1][i-1] = 1.0;
    xi[i-1]          = -g[i-1];
    sum             += p[i-1]*p[i-1];
  }
  stpmax = STPMX*FMAX(sqrt(sum),(double) n);

  for (its=1; its<=ITMAX; its++) {
    *iter = its;

    lnsrch(n,p,fp,g,xi,pnew,fret,stpmax,&check,func);

    fp = *fret;
    for (i=1; i<=n; i++) {
      xi[i-1] = pnew[i-1]-p[i-1];
      p[i-1]  = pnew[i-1];
    }
    test = 0.0;
    for (i=1; i<=n; i++) {
      temp = fabs(xi[i-1])/FMAX(fabs(p[i-1]),1.0);
      if (temp > test) test = temp;
    }
    if (test < TOLX) {
      free_dvector(dg);
      free_dvector(g);
      free_dvector(hdg);
      free_dvector(pnew);
      free_dvector(xi);
      free_dmatrix(hessin);
      return;
    }
    for (i=1; i<=n; i++) dg[i-1] = g[i-1];
    (*dfunc)(n,p,g);
    test = 0.0;
    den  = FMAX(*fret,1.0);
    for (i=1; i<=n; i++) {
      temp = fabs(g[i-1])*FMAX(fabs(p[i-1]),1.0)/den;
      if (temp > test) test = temp;
    }
    if (test < gtol) {
      free_dvector(xi);
      free_dvector(pnew);
      free_dmatrix(hessin);
      free_dvector(hdg);
      free_dvector(g);
      free_dvector(dg);
      return;
    }
    for (i=1; i<=n; i++) dg[i-1] = g[i-1]-dg[i-1];
    for (i=1; i<=n; i++) {
      hdg[i-1] = 0.0;
      for (j=1; j<=n; j++) hdg[i-1] += hessin[i-1][j-1]*dg[j-1];
    }
    fac = fae = sumdg = sumxi = 0.0;
    for (i=1; i<=n; i++) {
      fac   += dg[i-1]*xi[i-1];
      fae   += dg[i-1]*hdg[i-1];
      sumdg += SQR(dg[i-1]);
      sumxi += SQR(xi[i-1]);
    }
    if (fac*fac > EPS*sumdg*sumxi) {
      fac = 1.0/fac;
      fad = 1.0/fae;
      for (i=1; i<=n; i++) dg[i-1] = fac*xi[i-1] - fad*hdg[i-1];
      for (i=1; i<=n; i++) {
        for (j=1; j<=n; j++) {
          hessin[i-1][j-1] += fac*xi[i-1]*xi[j-1] - fad*hdg[i-1]*hdg[j-1] + fae*dg[i-1]*dg[j-1];
        }
      }
    }
    for (i=1; i<=n; i++) {
      xi[i-1] = 0.0;
      for (j=1; j<=n; j++) xi[i-1] -= hessin[i-1][j-1]*g[j-1];
    }
  }

  printf("too many iterations in dfpmin\n");
  free_dvector(xi);
  free_dvector(pnew);
  free_dmatrix(hessin);
  free_dvector(hdg);
  free_dvector(g);
  free_dvector(dg);
}
