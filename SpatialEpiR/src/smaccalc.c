#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "smacc.h"

#define PI 3.141592653589793116
#define NKERNEL(x,y,h) exp(-(SQR(x) + SQR(y))/(2*SQR(h)))/(2*PI*SQR(h))
#define QKERNEL(x,y,h) (3*SQR(1-(SQR(x) + SQR(y))/SQR(h)))/(PI*SQR(h)) /* taken from Julias course notes */
#define g(i,h) (smooth(x[i],y[i],h))

static double **cov;

static long int *cc;          /* Indicators for case-controls; 1 - case, 0 - control */
static double *x, *y;         /* xy - coordinates */
static long int N;            /* No. of persons = No. of data lines */
static long int nocov;        /* No. of covariates */
static long int notup;        /* No. of tuples */
static long int sztup;        /* Size of each tuple */
static long int matched;      /* Indicator for matched (1) or un-matched (0) analysis */
static double *hvals;         /* Vector of possible bandwith values */
static long int nohvals;      /* Length of hvals */
static long int Iedge;        /* Indicator for edge correction */
static double *edgeoff;       /* Start of vector of edge corrections */
static double *edgecor;       /* Current subvector of edge corrections being used*/
static double *s, *w;         /* Allocated when smaccest is called or in initmcmc() */
static double *z, *p;         /* Allocated in initsmaccest() and initmcmc()  */
static double ***vblocks;     /* Array of block diagonal matrices of V */

static double h;              /* The used bandwith parameter value */

/* global variables used only in mcmc() and betamcmc() and functions called in these: */
static double *origx;
static double *origy;
static long int *origcc;
static double **origcov;
static double *origedgecor;

/* ---------------------------- INITIALISATION ------------------------------------- */
/* Initialising functions and their respective cleanup'ers for the surface estimating
   function, smaccest and the tolerance curve calculation function, mcmc. */
static int initsmaccest(double *covvec) {

    int offset, i, j;

    p = dvector(N);
    z = dvector(N);

    if (matched) {
        vblocks = ppdvector(notup);
        for (i=0; i<notup; i++) vblocks[i] = dmatrix(sztup,sztup);
    } else {
        vblocks = ppdvector(N);
        for (i=0; i<N; i++) vblocks[i] = dmatrix(1,1);
        nocov += 1;   /* including a constant term */
    }

    /* Create and initialise covariate matrix from the covariate vector */
    if (nocov>0) {
       cov = dmatrix(N,nocov);
       offset = 0;
       if (!matched) {
         for (i=0; i<N; i++) cov[i][0] = 1;
         offset = 1;
       }
       for (j=0; j<nocov-offset; j++)
         for (i=0; i<N; i++)
            cov[i][j+offset] = covvec[j*N+i];
    }

    /* Initialise the g function to 0 */
    for (i=0; i<N; i++) { s[i]=0; w[i]=1; }

    /*  Print a lot of analysis details and other good stuff ... */
    if (matched) printf("Matched "); else printf("Unmatched ");
    printf("analysis requested.\n");
    printf("Number of covariates           : %ld\n",nocov);
    printf("Number of observations         : %ld\n",N);
    if (matched) {
        printf("Number of tuples               : %ld\n",notup);
        printf("Tuple size                     : %ld\n",sztup);
    }

    return(0);
}

static void cleanupsmaccest(void) {

    int i;

    free_dvector(p);
    free_dvector(z);

    if (matched) {
        for (i=0; i<notup; i++) free_dmatrix(vblocks[i]);
    } else {
        for (i=0; i<N; i++) free_dmatrix(vblocks[i]);
    }
    free_ppdvector(vblocks);

    if (nocov>0) free_dmatrix(cov);

    return;
}

static void initmcmc(double *covvec, double *surfacevec,
                     long int **probmat, double **surface,
                     long int ngridx, long int ngridy, long int seed) {

  int offset, i, j;

  /* all globally defined: */
  origx  = dvector(N);
  origy  = dvector(N);
  origcc = livector(N);
  p      = dvector(N);
  z      = dvector(N);
  s      = dvector(N);
  w      = dvector(N);

  /* Initialise the random number generator: */
  initran1(seed);

  if (matched) {
    vblocks = ppdvector(notup);
    for (i=0; i<notup; i++) vblocks[i] = dmatrix(sztup,sztup);
  } else {
    vblocks = ppdvector(N);
    for (i=0; i<N; i++) vblocks[i] = dmatrix(1,1);
    nocov += 1;   /* includes a constant term */
  }

  /* Create and initialise covariate matrix from the covariate vector */
  if (nocov>0) {
    cov     = dmatrix(N,nocov);      /* defined globally in smaccalc */
    origcov = dmatrix(N,nocov);      /* defined globally in smaccalc */
    offset  = 0;
    if (!matched) {
      for (i=0; i<N; i++) cov[i][0] = 1;
      offset = 1;
    }
    for (j=0; j<nocov-offset; j++) {
      for (i=0; i<N; i++)
        cov[i][j+offset] = covvec[j*N+i];
    }
  }

  /* Create and initialise probmat and surface: */
  for (j=0; j<ngridy; j++)
    for (i=0; i<ngridx; i++) {
      probmat[i][j] = 0;
      surface[i][j] = surfacevec[j*ngridx+i];
    }

  /* Initialise the g function to 0 */
  for (i=0; i<N; i++) { s[i]=0; w[i]=1; }

  if (Iedge) {
    origedgecor = dvector(N);
    veccopy(edgecor,N,origedgecor);
  }

  /* Make copies of the original x,y,cov and cc variables such that these can be altered */
  if (nocov>0)
    matcopy(cov,N,nocov,origcov);
  veccopy(x,N,origx);
  veccopy(y,N,origy);
  liveccopy(cc,N,origcc);

  return;
}

static void cleanupmcmc(void) {

  int i;

  free_dvector(origx);
  free_dvector(origy);
  free_livector(origcc);
  free_dvector(p);
  free_dvector(z);
  free_dvector(s);
  free_dvector(w);

  if (matched)
    for (i=0; i<notup; i++) free_dmatrix(vblocks[i]);
  else
    for (i=0; i<N; i++) free_dmatrix(vblocks[i]);
  free_ppdvector(vblocks);

  if (nocov>0) {
    free_dmatrix(cov);
    free_dmatrix(origcov);
  }

  if (Iedge)
    free_dvector(origedgecor);

  return;
}

static void initbetamcmc(double *covvec, long int seed) {

  int offset, i, j;

  /* all globally defined: */
  origx  = dvector(N);
  origy  = dvector(N);
  origcc = livector(N);
  p      = dvector(N);
  z      = dvector(N);
  s      = dvector(N);
  w      = dvector(N);

  /* Initialise the random number generator: */
  initran1(seed);

  if (matched) {
    vblocks = ppdvector(notup);
    for (i=0; i<notup; i++) vblocks[i] = dmatrix(sztup,sztup);
  } else {
    vblocks = ppdvector(N);
    for (i=0; i<N; i++) vblocks[i] = dmatrix(1,1);
    nocov += 1;   /* includes a constant term */
  }

  /* Create and initialise covariate matrix from the covariate vector */
  if (nocov>0) {
    cov     = dmatrix(N,nocov);      /* defined globally in smaccalc */
    origcov = dmatrix(N,nocov);      /* defined globally in smaccalc */
    offset  = 0;
    if (!matched) {
      for (i=0; i<N; i++) cov[i][0] = 1;
      offset = 1;
    }
    for (j=0; j<nocov-offset; j++) {
      for (i=0; i<N; i++)
        cov[i][j+offset] = covvec[j*N+i];
    }
  }

  /* Initialise the g function to 0 */
  for (i=0; i<N; i++) { s[i]=0; w[i]=1; }

  if (Iedge) {
    origedgecor = dvector(N);
    veccopy(edgecor,N,origedgecor);
  }

  /* Make copies of the original x,y,cov and cc variables such that these can be altered */
  if (nocov>0)
    matcopy(cov,N,nocov,origcov);
  veccopy(x,N,origx);
  veccopy(y,N,origy);
  liveccopy(cc,N,origcc);

  return;
}

static void cleanupbetamcmc(void) {

  int i;

  free_dvector(origx);
  free_dvector(origy);
  free_livector(origcc);
  free_dvector(p);
  free_dvector(z);
  free_dvector(s);
  free_dvector(w);

  if (matched)
    for (i=0; i<notup; i++) free_dmatrix(vblocks[i]);
  else
    for (i=0; i<N; i++) free_dmatrix(vblocks[i]);
  free_ppdvector(vblocks);

  if (nocov>0) {
    free_dmatrix(cov);
    free_dmatrix(origcov);
  }

  if (Iedge)
    free_dvector(origedgecor);

  return;
}

/* -------------------------------- Kernel smoothing ------------------------------- */
/* NOTE: The kernel function NKERNEL(x,y,h) is the bivariate normal kernel
   with bandwith h, evaluated at (x,y) while the kernel QKERNEL is the quartic kernel
   with bandwith h and evaluated at (x,y). */

/* The Kernel smoothing function using the current value of the global
   parameters w and s - in any location (xc,yc) in the plane */
static double smooth(double xc, double yc, double hval) {

    int i;
    double temp, numsum, densum, frac;

    numsum = 0.0;
    densum = 0.0;
    frac = 0.0;
    for (i=0; i<N; i++) {
      temp = w[i]*NKERNEL(xc-x[i],yc-y[i],hval);
      if (Iedge) temp /= edgecor[i];
      //del
      //printf("i :%d, edgecor : %20.14f, temp : %20.14f\n",i,edgecor[i],temp);
      numsum += temp*s[i];
      densum += temp;
    }
    if (densum>0) frac = numsum/densum;
    else {
      frac = 0;
      printf("WARNING (smooth): Division by zero was attempted in the kernel smoothing\n");
    }
    return(frac);
}

/* -------------------------- Cross validation functions --------------------------- */
static double crossval(double hvalue) {

  int i,j,k,count;
  double sum,temp,numsum,densum;

  if (matched) {
    sum = 0.0; count = 0;
    for (i=0; i<N; i++) {
      if (cc[i] == 1) count += 1;
      temp = 0.0;
      numsum = 0.0;
      densum = 0.0;
      for (j=0; j<notup; j++)
        if (j != (count-1)) {
          for (k=0; k<sztup; k++) {
            temp = w[j*sztup +k]*NKERNEL(x[i]-x[j*sztup+k],y[i]-y[j*sztup+k],hvalue);
            if (Iedge) temp /= edgecor[j*sztup+k];
            numsum += temp*s[j*sztup+k];
            densum += temp;
          }
        }
      if (densum>0)
        temp = numsum/densum;
      else {
        temp = 0;
        printf("WARNING: Division by zero attempted in calculating the CV criterion for tuple %d\n",i);
      }
      sum += w[i]*SQR(z[i]-temp);
    }
  } else {
    sum = 0.0;
    for (i=0; i<N; i++) {
      temp = 0.0;
      numsum = 0.0;
      densum = 0.0;
      for (j=0; j<N; j++)
        if (j != i) {
          temp = w[j]*NKERNEL(x[i]-x[j],y[i]-y[j],hvalue);
          if (Iedge) temp /= edgecor[j];
          numsum += temp*s[j];
          densum += temp;
        }
      if (densum>0)
        temp = numsum/densum;
      else {
        temp = 0;
        printf("WARNING: Division by zero attempted in calculating the CV criterion for tuple %d\n",i);
      }
      sum += w[i]*SQR(z[i]-temp);
    }
  }
  return(sum/N);
}

static void CVloop(double *cvvec, double *hpicked) {

  long int i,imin;

  imin=0;
  for (i=0; i<nohvals; i++) {
    if (Iedge) edgecor = &edgeoff[i*N];
    cvvec[i] = crossval(hvals[i]);
    if (cvvec[i] < cvvec[imin]) imin = i;
  }

  if (Iedge) edgecor = &edgeoff[imin*N];
  *hpicked=hvals[imin];
  return;
}

// This calculates the g^{-tupnr}(x_{tupnr,nrintup}) for a given tupple, point in tupple and bandwidth:
// OBS: Make sure that the edgecorr is pointing to the right place at the beginning!!
static double likfunc1(int tupnr, int nrintup, double hvalue) {

  int j,k;
  double temp,numsum,densum;

  if (matched) {
    temp   = 0.0; numsum = 0.0; densum = 0.0;
    for (j=0; j<notup; j++)
      if (j != tupnr) {
        for (k=0; k<sztup; k++) {
          temp = w[j*sztup +k]*NKERNEL(x[tupnr*sztup+nrintup]-x[j*sztup+k],
                                       y[tupnr*sztup+nrintup]-y[j*sztup+k],
                                       hvalue);
          if (Iedge) temp /= edgecor[j*sztup+k];
          numsum += temp*s[j*sztup+k];
          densum += temp;
        }
      }
    if (densum>0)
      temp = numsum/densum; // This is g^{-tupnr}(x_{tupnr,nrintup}) for matched data
    else {
      temp = 0;
      printf("WARNING: Division by zero attempted in calculating the likelihood-CV criterion for tuple %d\n",tupnr);
    }
  } else {
    temp = 0.0; numsum = 0.0; densum = 0.0;
    for (j=0; j<N; j++)
      if (j != tupnr) {
        temp = w[j]*NKERNEL(x[tupnr]-x[j],y[tupnr]-y[j],hvalue);
        if (Iedge) temp /= edgecor[j];
        numsum += temp*s[j];
        densum += temp;
      }
    if (densum>0)
      temp = numsum/densum; // This is g^{-tupnr}(x_{tupnr,0}) for unmatched data
    else {
      temp = 0;
      printf("WARNING: Division by zero attempted in calculating the likelihood-CV criterion for tuple %d\n",tupnr);
    }
  }

  return(temp);
}

// This function calculates the likelihood-cross validation criterion for a given bandwidth:
static double likfunc2(double hvalue,int dimbeta, double *beta) {

  int i, j, k;
  double sum1, sum2, temp1, temp2;

  if (matched) {
    sum1 = 0.0;
    for (i=0; i<N; i++)
      if (cc[i]==1) {
        temp1 = 0.0;
        for (j=0; j<dimbeta; j++)
          temp1 += cov[i][j]*beta[j];
        sum1 += temp1 + likfunc1(i/sztup,0,hvalue);        // first point in each tupple
        sum2 = 0.0;
        for (k=0; k<sztup; k++) {
          temp1 = 0.0;
          for (j=0; j<dimbeta; j++)
            temp1 += cov[i+k][j]*beta[j];
          sum2 += exp(temp1 + likfunc1(i/sztup,k,hvalue)); // k'th point in each tupple
        }
        sum1 = sum1 - log(sum2);
      }
    return(-sum1/notup);
  } else {
    sum1 = 0.0;
    for (i=0; i<N; i++) {
      temp2 = 0.0;
      for (j=0; j<dimbeta; j++)
        temp2 += cov[i][j]*beta[j];
      temp2 += likfunc1(i,0,hvalue);                 // first point in each tupple - there is only one !!

      temp1 = 0.0;
      if (cc[i]==1) temp1 = temp2;

      sum1 += temp1 - log(1 + exp(temp2));
    }
    return(-sum1/N);
  }
}


/* ------------------------------ Updating function ----------------------------------- */
/* Calculates success probabilities, corresponding weights, the adjusted dependent
   variable and the covariance block-matrices */
static void new_data(int dimbeta, double *beta, double *pvec, double *weight, double *zvec) {

  int i, j, k, l, cnttup;
  double sum, temp1, eta1;
  double *temp, *eta;

  temp = dvector(sztup);
  eta  = dvector(sztup);

  if (matched) {
    cnttup = 0;
    for (i=0; i<N; i++) {
      if (cc[i] == 1) {
        sum = 0.0;
        for (k=0; k<sztup; k++) {
          temp1 = 0.0;
          for (j=0; j<dimbeta; j++)
            temp1 += cov[i+k][j]*beta[j];
          eta[k] = temp1 + g(i+k,h);          /* Note: the current h is used here!! */
          temp[k] = exp(eta[k]);
          sum += temp[k];
        }
        for (k=0; k<sztup; k++) {
          pvec[i+k] = temp[k]/sum;
          weight[i+k] = pvec[i+k]*(1 - pvec[i+k]);
          if (weight[i+k]<0.000001) weight[i+k] = 0.000001;
          if ((pvec[i+k]<0.000001) && (cc[i+k]==0))
            zvec[i+k] = eta[k] - 1;
          else if ((pvec[i+k]>0.999999) && (cc[i+k]==1))
            zvec[i+k] = eta[k] + 1;
          else if ((pvec[i+k]<0.000001) && (cc[i+k]==1)) {
            zvec[i+k] = eta[k] + 1000000;
            printf("1: Miss match in the calculation of the adjusted dependent variable zvec[%d]\n",i+k);
          }
          else if ((pvec[i+k]>0.999999) && (cc[i+k]==0)) {
            zvec[i+k] = eta[k] - 1000000;
            printf("2: Miss match in the calculation of the adjusted dependent variable zvec[%d]\n",i+k);
          }
          else zvec[i+k] = eta[k] + (cc[i+k] - pvec[i+k])/(pvec[i+k]*(1-pvec[i+k]));
        }
        for (k=0; k<sztup; k++) {
          vblocks[cnttup][k][k] = 1/weight[i+k];
          for (l=0; l<k; l++) {
            temp1 = (1-pvec[i+k])*(1-pvec[i+l]);
            if (temp1<0.000001) temp1 = 0.000001;
            vblocks[cnttup][k][l] = -1/temp1;
            vblocks[cnttup][l][k] = vblocks[cnttup][k][l];
          }
        }
        cnttup++;
      }
    }
    free_dvector(temp);
    free_dvector(eta);
    return;

  } else {
    //del
    //printf("new_data entered\n");
    //for (i=0; i<N; i++) { printf("i : %d, W : %f, s : %f, g : %f\n",i,w[i],s[i],g(i,h));}
    for (i=0; i<N; i++) {
      temp1 = 0.0;
      for (j=0; j<dimbeta; j++)
        temp1 += cov[i][j]*beta[j];
      eta1 = temp1 + g(i,h);         /* Note: the current h is used here!! */
      temp1 = exp(eta1);
      pvec[i] = temp1/(1 + temp1);
      weight[i] = pvec[i]*(1 - pvec[i]);
      if (weight[i]<0.000001) weight[i] = 0.000001;
      if ((pvec[i]<0.000001) && (cc[i]==0))
        zvec[i] = eta1 - 1;
      else if ((pvec[i]>0.999999) && (cc[i]==1))
        zvec[i] = eta1 + 1;
      else if ((pvec[i]<0.000001) && (cc[i]==1)) {
        zvec[i] = eta1 + 1000000;
        printf("Miss match in the calculation of the adjusted dependent variable zvec[%d]\n",i);
      }
      else if ((pvec[i]>0.999999) && (cc[i]==0)) {
        zvec[i] = eta1 - 1000000;
        printf("Miss match in the calculation of the adjusted dependent variable zvec[%d]\n",i);
      }
      else zvec[i] = eta1 + (cc[i] - pvec[i])/(pvec[i]*(1-pvec[i]));
      vblocks[i][0][0] = 1/weight[i];
    }
    //del
    //printf("new_data left\n");
    free_dvector(temp);
    free_dvector(eta);
    return;
  }
}

/* --------------------- The likelihood functions and their derivatives ---------------- */
/* Calculates the value of minus the log-likelihood at beta for fixed g */
static double mlogL(int dimbeta, double *beta) {

  int i, j, k;
  double sum1, sum2, temp1, temp2;

  if (matched) {
    sum1 = 0.0;
    for (i=0; i<N; i++)
      if (cc[i]==1) {
        temp1 = 0.0;
        for (j=0; j<dimbeta; j++)
          temp1 += cov[i][j]*beta[j];
        sum1 += temp1 + g(i,h);         /* Note: the current h is used here!! */
        sum2 = 0.0;
        for (k=0; k<sztup; k++) {
          temp1 = 0.0;
          for (j=0; j<dimbeta; j++)
            temp1 += cov[i+k][j]*beta[j];
          sum2 += exp(temp1+g(i+k,h));         /* Note: the current h is used here!! */
        }
        sum1 = sum1 - log(sum2);
      }
    return(-sum1);
  } else {
    sum1 = 0.0;
    for (i=0; i<N; i++) {
      temp2 = 0.0;
      for (j=0; j<dimbeta; j++) temp2 += cov[i][j]*beta[j];
      temp2 += g(i,h);                         /* Note: the current h is used here!! */

      temp1 = 0.0;
      if (cc[i]==1) temp1 = temp2;

      sum1 += temp1 - log(1 + exp(temp2));
    }
    return(-sum1);
  }
}

/* Calculates the first derivative of minus the log-likelihood at beta for fixed g */
static void ld(int dimbeta, double *beta, double *ldvec) {

  int i, j, k, l;
  double sum1, densum, numsum, temp1;

  if (matched) {
    for (l=0; l<dimbeta; l++) {
      sum1 = 0.0;
      for (i=0; i<N; i++)
        if (cc[i]==1) {
          numsum = 0.0;  /* numerator */
          densum = 0.0;  /* denominator */
          for (k=0; k<sztup; k++) {
            temp1 = 0.0;
            for (j=0; j<dimbeta; j++)
              temp1 += cov[i+k][j]*beta[j];
            temp1 = exp(temp1+g(i+k,h));         /* Note: the current h is used here!! */
            numsum += cov[i+k][l]*temp1;
            densum += temp1;
          }
          sum1 += cov[i][l] - numsum/densum;
        }
      ldvec[l] = -sum1;
    }
    return;
  } else {
    for (l=0; l<dimbeta; l++) {
      sum1 = 0.0;
      for (i=0; i<N; i++) {
        if (cc[i]==1) sum1 += cov[i][l];
        temp1 = 0.0;
        for (j=0; j<dimbeta; j++)
          temp1 += cov[i][j]*beta[j];
        temp1 = exp(temp1 + g(i,h));         /* Note: the current h is used here!! */
        // if (temp1>1e20) temp1 = 1e20;        /* is this a reasenable limit? */
        sum1 -= cov[i][l]*(temp1/(1 + temp1));
      }
      ldvec[l] = -sum1;
      //printf("ldvec is : %6.2f\n",ldvec[l]);
    }
    return;
  }
}

/* Calculates the second derivative of minus the log-likelihood at beta for fixed g */
static void ldd(int dimbeta, double *beta, double **lddmat) {

  int i, j, k, l, m;
  double sum1, sum, sum_lw, sum_mw, sum_lmw, temp1;

  if (matched) {
    for (l=0; l<dimbeta; l++)
      for (m=0; m<=l; m++) {
        sum1 = 0.0;
        for (i=0; i<N; i++)
          if (cc[i]==1) {
            sum     = 0.0;
            sum_lw  = 0.0;
            sum_mw  = 0.0;
            sum_lmw = 0.0;
            for (k=0; k<sztup; k++) {
              temp1 = 0.0;
              for (j=0; j<dimbeta; j++)
                temp1 += cov[i+k][j]*beta[j];
              temp1   = exp(temp1+g(i+k,h));         /* Note: the current h is used here!! */
              sum     += temp1;
              sum_lw  += cov[i+k][l]*temp1;
              sum_mw  += cov[i+k][m]*temp1;
              sum_lmw += cov[i+k][l]*cov[i+k][m]*temp1;
            }
            sum1 += (sum_lmw*sum-sum_lw*sum_mw)/(sum*sum);
          }
        lddmat[l][m] = sum1;
        lddmat[m][l] = sum1;
      }
    return;
  } else {
    for (l=0; l<dimbeta; l++) {
      for (m=0; m<=l; m++) {
        sum1 = 0.0;
        for (i=0; i<N; i++) {
          temp1 = 0.0;
          for (j=0; j<dimbeta; j++)
            temp1 += cov[i][j]*beta[j];         /* Note: the current h is used here!! */
          temp1 = exp(temp1 + g(i,h))/((1 + exp(temp1 + g(i,h)))*(1 + exp(temp1 + g(i,h))));
          sum1 += cov[i][l]*cov[i][m]*temp1;
          //printf("temp1, sum1 and i in ldd is %16.14f %16.14f %6d\n",temp1,sum1,i);
        }
        lddmat[l][m] = sum1;
        lddmat[m][l] = sum1;
      }
    }
    return;
  }
}
/* -------------------- End of likelihood functions and derivatives ------------------- */

/* ------------------------------ Estimation ------------------------------------------ */
/* This function controls the iterative steps in the model-fitting procedure.
   It estimates beta and g (through s and w), and saves the last vector of
   cross-validation values in cvvec and the corresponding optimal h. */
static int estimate(long int outermax, long int innermax, double *beta, double tolbeta,
                    double tolg, double *cvvec, double *varbeta, long int Imcmc) {

    /* For the calculations of the Fisher information matrix at the end */
    double **d2logL, **d2inv;

    int i, j, k, l, innerconv, outerconv, check, convindi;
    double *b, *oldb;
    double *oldg, *f, *oldf;
    double distbeta, distb, distg, distf;
    double temp;

    if (nocov>0) {
      b    = dvector(nocov);    /* Same as beta */
      oldb = dvector(nocov);
    }
    oldg = dvector(N);
    f    = dvector(N);
    oldf = dvector(N);

    /* Only performed once in each call to get initial estimates of beta */
    if (nocov>0) newt_an(beta, nocov, &check, ld, ldd);

    // DEL
    //for (i=0; i<nocov; i++)
    //printf("beta%d : %f\n",i,beta[i]);

    l = 0;
    do {  /* Outer loop begins */
        l++;

        new_data(nocov,beta,p,w,z);       /* Also changes vblocks */

        for (i=0; i<nocov; i++) oldb[i] = beta[i];
        for (i=0; i<N; i++) {
           oldg[i] = g(i,h);
           oldf[i] = oldg[i]; } /* Note: the current h is used here!! */


        k = 0;
        do { /* Inner loop begins */
            k++;

            for (i=0; i<N; i++) {
                temp = 0.0;
                for (j=0; j<nocov; j++) temp += cov[i][j]*oldb[j];
                s[i] = z[i] - temp;      /* Changes implicitly g */
            }
            /* Normalize s to have overall mean 0 */
            /* Should always be included in the matched case (where it does not  */
            /* make sense to have a constant term/covariate)                     */
            /* For the unmatched case either:                                    */
            /* a) normalize s and include a constant term/covariate, (DONE) or   */
            /* b) do not normalize s and do not include a constant term.         */
            temp = 0.0;
            for (i=0; i<N; i++) temp += s[i];
            temp = temp/N;
            for (i=0; i<N; i++) s[i] -= temp;

            /* The global bandwith parameter, h is chosen from the vector hvals: */
            if (nohvals>1) CVloop(cvvec, &h);

            distf = 0.0;
            for (i=0; i<N; i++) {
                f[i] = g(i,h);          /* HERE the smoothing is done! */
                distf += SQR(f[i]-oldf[i]);
                oldf[i] = f[i];
                //del
                //printf("i : %d, distf : %f\n",i,distf);
            }

            /* Maximum likelihood estimation of beta based on the new f (=g) */
            if (nocov>0) newt_an(b,nocov, &check, ld, ldd);

            distb = 0.0;
            for (j=0; j<nocov; j++) {
                distb += SQR(b[j]-oldb[j]);
                oldb[j] = b[j];
            }
            innerconv = ((distf <= tolg) && (distb <= tolbeta));

        } while ((k<innermax) && (!innerconv));  /* Inner loop ends */
        if (!innerconv) {
            printf("No convergence in inner loop after %ld iterations (distf=%10.6f)\n",innermax,distf);
        }

        distg = 0.0;
        for (i=0; i<N; i++) {
            distg += SQR(oldg[i]-f[i]);
        }

        distbeta = 0.0;
        for (j=0; j<nocov; j++) {
            distbeta += SQR(beta[j]-b[j]);
            beta[j]=b[j];
        }
        outerconv = ((distg <= tolg) && (distbeta <= tolbeta));

    } while ((l<outermax) && (!outerconv));  /* Outer loop ends */

    // DEL: THESE TWO STATEMENTS CAN ONLY BE USED FROM FITSMACC!! NOT FROM TOLSMACC!!
    // calculating the cross validation value for the one bandwidth parameter given:
    //if (nohvals==1) {
    //if (Iedge) edgecor = &edgeoff[0];
    //cvvec[0] = crossval(h);
    //}

    // calculating the likelihood-crossvalidation value for the one bandwidth parameter given:
    //if (nohvals==1) {
    //if (Iedge) edgecor = &edgeoff[0];
    //cvvec[0] = likfunc2(h,nocov,beta);
    //}

    if (!outerconv) {
        printf("No convergence in outer loop after %ld iterations (distg=%10.6f)\n",outermax,distg);
        convindi=0;
    } else {
        printf("Convergence in outer loop after %d iterations (distg=%10.6f)\n",l,distg);
        if (!Imcmc)
          if (nocov>0) {/* calculate the Fisher inf. matrix for the final estimate of beta */
            d2logL = dmatrix(nocov,nocov);
            d2inv  = dmatrix(nocov,nocov);
            ldd(nocov,beta,d2logL);
            matinv(d2logL,nocov,d2inv);
            for (j=0; j<nocov; j++)
              varbeta[j] = d2inv[j][j];
          }
        convindi=1;
    }

    if (nocov>0) {
      free_dvector(b);
      free_dvector(oldb);
    }
    free_dvector(oldg);
    free_dvector(f);
    free_dvector(oldf);

    return(convindi);
}

/* --------------------------- Functions used for the mcmc bit --------------------- */
static void update(double *xgrid, double *ygrid, int nx, int ny, long int *Ipoly,
                   double **surface, long int **pmat, double *t) {

/*
  xgrid      is the vector of x-coordinates making up the grid
  ygrid      is the vector of y-coordinates making up the grid
  nx         is the length of xgrid
  ny         is the length of ygrid (i.e. nx*ny is the number of points in the grid)
  Ipoly      an indicator vector which indicates which points are in and out of the polygon
  surface    is a matrix containing the originaly estimated surface
  pmat       is returned as the updated matrix counting the number of the simulations whos
             surfaces lie beneath the original one
  t          is returned as the value of the teststatistics for the current surface
*/

  int i,j;
  double temp, sum, sqsum, mean, newsurface;

  temp  = 0;
  sum   = 0;
  sqsum = 0;
  mean  = 0;

  for (i=0; i<N; i++) {
    temp   = g(i,h);
    sum   += temp;
    sqsum += SQR(temp);
  }
  mean = sum/N;
  *t   = (sqsum - 2*mean*sum + N*SQR(mean))/N;  /* subtracting the mean surface */

  for (j=0; j<ny; j++)
    for (i=0; i<nx; i++)
      if (Ipoly[j*nx +i]) {
        newsurface = smooth(xgrid[i],ygrid[j],h);
        if ((newsurface - mean) < surface[i][j]) pmat[i][j] += 1;
      }
}

static void smaccmcmc(long int nsim, long int nocases, long int **probmat, double *tvec,
                      long int *succvec, long int *pnconv,
                      double *xgrid, double *ygrid, long int ngridx, long int ngridy,
                      long int *Ipoly,
                      double **surface, long int outermax, long int innermax,
                      double tolbeta, double tolg) {

  long int Imcmc;
  int i, j, k, r, check, *select;
  double cvdummy, varbetadummy, *pdist, *beta;

  *pnconv  = 0;  /* Number of succesful convergences in estimate */
  Imcmc    = 1;  /* indicator to be feed to estimate - if 0 the Fisher Inf. is calculated */

  if (nocov>0)
    beta = dvector(nocov);
  else beta = NULL;

  pdist = dvector(N);
  if (!matched)
    select = ivector((int) nocases);

  /* calculate the probability distribution to sample from */
  for (j=0; j<nocov; j++) beta[j] = 0.1;   /* initialise beta - g is initialised in initmcmc*/
  if (nocov>0)
    newt_an(beta, nocov, &check, ld, ldd);
  new_data(nocov,beta,p,w,z);
  veccopy(p,N,pdist);

  for (i=0; i<nsim; i++) {  /* The relabeling loop */
    printf("Tolsmacc: estimating the relabeled surface no %4d\n",i);
    if (matched) {
      if (nocov>0)
        matcopy(origcov,N,nocov,cov);
      veccopy(origx,N,x);
      veccopy(origy,N,y);
      if (Iedge)
        veccopy(origedgecor,N,edgecor);

      for (j=0; j<notup; j++) {
        r = samplematch(&pdist[j*sztup], sztup);
        if (r>0) {
          if (nocov>0)
            for (k=0; k<nocov; k++) {
              cov[j*sztup][k]   = origcov[j*sztup+r][k];
              cov[j*sztup+r][k] = origcov[j*sztup][k];
            }
          x[j*sztup]     = origx[j*sztup+r];
          x[j*sztup+r]   = origx[j*sztup];
          y[j*sztup]     = origy[j*sztup+r];
          y[j*sztup+r]   = origy[j*sztup];
          if (Iedge) {
            edgecor[j*sztup]   = origedgecor[j*sztup+r];
            edgecor[j*sztup+r] = origedgecor[j*sztup];
          }
        }
      }

      /* Initialise beta and the g function (g to 0) before estimating the surface again */
      for (j=0; j<nocov; j++)
        beta[j] = 0.1;
      for (j=0; j<N; j++) { s[j]=0; w[j]=1; }

      /* Note that 'estimate' operates on the global variables cov,x,y ! */
      succvec[i] = estimate(outermax,innermax,beta,tolbeta,tolg,&cvdummy,&varbetadummy,Imcmc);
      *pnconv    += succvec[i];
      if (succvec[i]>0)
        update(xgrid, ygrid, ngridx, ngridy, Ipoly, surface, probmat, &tvec[i]);
    } else {
      for (j=0; j<N; j++)
        cc[j] = 0;

      sampleunmatch(pdist, N, select, nocases);

      for (j=0; j<nocases; j++)
        cc[select[j]] = 1;

      /* Initialise beta and the g function (g to 0) before estimating the surface again */
      for (j=0; j<nocov; j++)
        beta[j] = 0.1;
      for (j=0; j<N; j++) { s[j]=0; w[j]=1; }

      /* Note that 'estimate' operates on the global variable cc ! */
      succvec[i] = estimate(outermax,innermax,beta,tolbeta,tolg,&cvdummy,&varbetadummy,Imcmc);
      *pnconv    += succvec[i];
      if (succvec[i]>0)
        update(xgrid, ygrid, ngridx, ngridy, Ipoly, surface, probmat, &tvec[i]);
    }
  }   /* end of simulation loop */

  /* Copy the global variables back to their original values: */
  if (nocov>0)
    matcopy(origcov,N,nocov,cov);
  veccopy(origx,N,x);
  veccopy(origy,N,y);
  liveccopy(origcc,N,cc);
  if (Iedge)
    veccopy(origedgecor,N,edgecor);

  if (nocov>0) free_dvector(beta);
  free_dvector(pdist);
  if (!matched) free_ivector(select);

}

static void calcbetas(long int nsim, long int nocases, long int *succvec,
                      double **bhatmat, double **bhatvarmat, long int *pnconv,
                      long int outermax, long int innermax, double tolbeta,
                      double tolg) {

  long int Imcmc;
  int i, j, k, r, check, *select;
  double cvdummy, varbetadummy, *pdist, *beta;

  /* For the calculations of the Fisher information matrix */
  double **d2logL, **d2inv;

  *pnconv  = 0;  /* Number of surfaces actually converged*/
  Imcmc    = 1;  /* indicator to be feed to estimate - if 0 the Fisher Inf. is calculated */

  if (nocov>0) {
    beta   = dvector(nocov);
    d2logL = dmatrix(nocov,nocov);
    d2inv  = dmatrix(nocov,nocov);
  } else beta = NULL; /* Though this function is only of interest if nocov>0!! */

  pdist = dvector(N);
  if (!matched)
    select = ivector((int) nocases);

  /* first calculate the probability distribution to sample from - where g and beta
     are set to be their estimated values (from the true data). */
  for (j=0; j<nocov; j++) beta[j] = 0.1;
  estimate(outermax,innermax,beta,tolbeta,tolg,&cvdummy,&varbetadummy,Imcmc);
  veccopy(p,N,pdist); /* after 'estimate' p contains the wanted probability vector */

  for (i=0; i<nsim; i++) {  /* The relabeling loop */
    printf("Calcbeta: estimating the relabeled surface no %4d\n",i);
    if (matched) {
      if (nocov>0)
        matcopy(origcov,N,nocov,cov);
      veccopy(origx,N,x);
      veccopy(origy,N,y);
      if (Iedge)
        veccopy(origedgecor,N,edgecor);

      for (j=0; j<notup; j++) {
        r = samplematch(&pdist[j*sztup], sztup);
        if (r>0) {
          if (nocov>0)
            for (k=0; k<nocov; k++) {
              cov[j*sztup][k]   = origcov[j*sztup+r][k];
              cov[j*sztup+r][k] = origcov[j*sztup][k];
            }
          x[j*sztup]     = origx[j*sztup+r];
          x[j*sztup+r]   = origx[j*sztup];
          y[j*sztup]     = origy[j*sztup+r];
          y[j*sztup+r]   = origy[j*sztup];
          if (Iedge) {
            edgecor[j*sztup]   = origedgecor[j*sztup+r];
            edgecor[j*sztup+r] = origedgecor[j*sztup];
          }
        }
      }

      /* Initialise beta and the g function (g to 0) before estimating the surface again */
      for (j=0; j<nocov; j++)
        beta[j] = 0.1;
      for (j=0; j<N; j++) { s[j]=0; w[j]=1; }

      /* Note that 'estimate' operates on the global variables cov,x,y ! */
      succvec[i] = estimate(outermax,innermax,beta,tolbeta,tolg,&cvdummy,&varbetadummy,Imcmc);
      *pnconv    += succvec[i];
      if (succvec[i]>0) {
        if (nocov>0) {
          ldd(nocov,beta,d2logL);
          matinv(d2logL,nocov,d2inv);
        }
        for (j=0; j<nocov; j++) {
          bhatmat[i][j]    = beta[j];
          bhatvarmat[i][j] = d2inv[j][j];
        }
      }
    } else {
      for (j=0; j<N; j++)
        cc[j] = 0;

      sampleunmatch(pdist, N, select, nocases);

      for (j=0; j<nocases; j++)
        cc[select[j]] = 1;

      /* Initialise beta and g (g to 0) before estimating the surface again */
      for (j=0; j<nocov; j++)
        beta[j] = 0.1;
      for (j=0; j<N; j++) { s[j]=0; w[j]=1; }

      /* Note that 'estimate' operates on the global variable cc ! */
      succvec[i] = estimate(outermax,innermax,beta,tolbeta,tolg,&cvdummy,&varbetadummy,Imcmc);
      *pnconv    += succvec[i];
      if (succvec[i]>0) {
        if (nocov>0) {
          ldd(nocov,beta,d2logL);
          matinv(d2logL,nocov,d2inv);
        }
        for (j=0; j<nocov; j++) {
          bhatmat[i][j]    = beta[j];
          bhatvarmat[i][j] = d2inv[j][j];
        }
      }
    }
  }   /* end of simulation loop */


  /* Copy the global variables back to their original values: */
  if (nocov>0)
    matcopy(origcov,N,nocov,cov);
  veccopy(origx,N,x);
  veccopy(origy,N,y);
  liveccopy(origcc,N,cc);
  if (Iedge)
    veccopy(origedgecor,N,edgecor);

  if (nocov>0) {
    free_dvector(beta);
    free_dmatrix(d2logL);
    free_dmatrix(d2inv);
  }
  free_dvector(pdist);
  if (!matched) free_ivector(select);
}

/* --------------------------- The "Splus functions" -------------------------------- */

void calcCV(double *x_, double *y_, long int *cc_, double *s_,
            double *w_, double *innerprod, double *hvals_,
            long int *Iedge_, double *edgeoff_,
            double *cvvec, long int *N_,
            long int *notup_, long int *sztup_, long int *matched_,
            long int *nohvals_, double *h_) {

  int i;
  double hpick;

  /* Make the variables globally known */
  cc      = cc_;
  x       = x_;
  y       = y_;
  N       = *N_;
  notup   = *notup_;
  sztup   = *sztup_;
  matched = *matched_;
  hvals   = hvals_;
  nohvals = *nohvals_;
  Iedge   = *Iedge_;
  s       = s_;
  w       = w_;

  if (Iedge) {
    edgeoff = edgeoff_;
    edgecor = edgeoff_;  /* The correction corresponding to the first h value */
  }

  z = dvector(N);
  for (i=0; i<N; i++)
    z[i] = s[i] + innerprod[i];

  CVloop(cvvec,&hpick);
  *h_ = hpick;

  free_dvector(z);
}



/* If matched=0 then a constant term is automatically included, and beta should be of
   length nocov+1. If matched>0 then constant terms disappear from the likelihood
   function, hence is not included, and the length of beta should equal nocov */
/* This function does the hard work in estimating the risk surface (matched/unmatched) */
void smaccest(long int *cc_, double *covvec, double *x_, double *y_,
              long int *N_, long int *nocov_, long int *notup_, long int *sztup_,
              long int *matched_, double *hvals_, long int *nohvals_,
              long int *Iedge_, double *edgeoff_,
              double *cvvec, double *s_, double *beta, double *varbeta, double *w_, double *h_,
              long int *poutermax, long int *pinnermax, double *ptolbeta, double *ptolg) {

  long int Imcmc;

  Imcmc = 0; /* For the call to estimate -- if 1 it caculates the fisher information matrix */

  /* Make the variables globally known */
  cc      = cc_;
  x       = x_;
  y       = y_;
  N       = *N_;
  nocov   = *nocov_;
  notup   = *notup_;
  sztup   = *sztup_;
  matched = *matched_;
  hvals   = hvals_;
  nohvals = *nohvals_;
  Iedge   = *Iedge_;
  s       = s_;
  w       = w_;

  h       = *hvals;  /* The global h is set to the first value in the hvals vector */
  if (Iedge) {
    edgeoff = edgeoff_;
    edgecor = edgeoff_;  /* The correction corresponding to the first h value */
  }

  initsmaccest(covvec);

  estimate(*poutermax, *pinnermax, beta, *ptolbeta, *ptolg, cvvec, varbeta, Imcmc);
  *h_     = h;       // Set to the final value of the global bandwidth parameter h

  cleanupsmaccest();

}

/* This function does the hard work in estimating the tolerance curves (under
   the null hypothesis 'no spatial variation in risk' or 'g(x)=0') for an
   estimated risk surface in a matched or an unmatched study */
void mcmc(long int *pnsim, double *probvec, double *tvec, long int *succvec,
          double *xgrid, double *ygrid,
          long int *nx, long int *ny, long int *Ipoly, double *surfacevec, long int *cc_,
          double *covvec,
          double *x_, double *y_, long int *N_, long int *nocov_, long int *notup_,
          long int *sztup_, long int *pnocases, long int *matched_, double *h_,
          long int *Iedge_, double *edgeoff_,
          long int *poutermax, long int *pinnermax, double *ptolbeta, double *ptolg,
          long int *randomseed) {

  int i, j;
  long int **probmat, temp, nconv;
  double **surface;

  /* Make the variables globally known: */
  cc      = cc_;
  x       = x_;
  y       = y_;
  N       = *N_;
  nocov   = *nocov_;
  notup   = *notup_;
  sztup   = *sztup_;
  matched = *matched_;
  h       = *h_;
  Iedge   = *Iedge_;

  if (Iedge) edgecor = edgeoff_; /* There is only one vector of corrections */

  nohvals = 1;  /* The h value is fixed when estimating the relabeled datasets! */

  probmat = limatrix(*nx, *ny);
  surface = dmatrix(*nx,*ny);

  initmcmc(covvec, surfacevec, probmat, surface, *nx, *ny, *randomseed);

  smaccmcmc(*pnsim, *pnocases, probmat, tvec, succvec, &nconv,
            xgrid, ygrid, *nx, *ny, Ipoly, surface,
            *poutermax, *pinnermax, *ptolbeta, *ptolg);

  /* Reading probmat into the vector probvec and dividing by the number
     of simulations performed:*/
  for (j=0; j<*ny; j++)
    for (i=0; i<*nx; i++)
      probvec[j*(*nx) + i] = ((double) probmat[i][j])/((double) nconv);

  free_limatrix(probmat);
  free_dmatrix(surface);
  cleanupmcmc();

  return;
}

/* This function does the hard work in estimating the beta's several times under
   the null hypothesis of 'g(x)=g-hat(x)' (matched or unmatched study) */
void betamcmc(long int *pnsim, long int *succvec, double *varbhat, double *meanfishervar,
              long int *cc_, double *covvec,
              double *x_, double *y_, long int *N_, long int *nocov_,
              long int *notup_, long int *sztup_, long int *pnocases,
              long int *matched_, double *h_, long int *Iedge_, double *edgeoff_,
              long int *poutermax, long int *pinnermax, double *ptolbeta,
              double *ptolg, long int *randomseed) {

  int i, j;
  long int nconv;
  double **bhatmat, **bhatvarmat;
  double *sumtemp, *meantemp, *vartemp;

  /* Make the variables globally known: */
  cc      = cc_;
  x       = x_;
  y       = y_;
  N       = *N_;
  nocov   = *nocov_;
  notup   = *notup_;
  sztup   = *sztup_;
  matched = *matched_;
  h       = *h_;
  Iedge   = *Iedge_;

  if (Iedge) edgecor = edgeoff_; /* There is only one vector of correction values */

  nohvals = 1;  /* h is fixed when estimating the surfaces of the relabeled datasets! */

  initbetamcmc(covvec, *randomseed);

  if (nocov>0) {
    bhatmat    = dmatrix(*pnsim,nocov);
    bhatvarmat = dmatrix(*pnsim,nocov);
    sumtemp    = dvector(nocov);
    meantemp   = dvector(nocov);
    vartemp    = dvector(nocov);
    for (i=0; i<*pnsim; i++)
      for (j=0; j<nocov; j++) {
        bhatmat[i][j]    = 0.0;
        bhatvarmat[i][j] = 0.0;
      }
  }

  calcbetas(*pnsim, *pnocases, succvec, bhatmat, bhatvarmat, &nconv,
            *poutermax, *pinnermax, *ptolbeta, *ptolg);

  /* Transforming bhatmat & bhatvarmat into the vectors varbhat & meanfishervar
     takeing account of nonconverged surfaces!! */
  for (j=0; j<nocov; j++) {
    sumtemp[j]  = 0.0;
    meantemp[j] = 0.0;
    vartemp[j]  = 0.0;
  }
  if (nconv>1) {
    for (i=0; i<*pnsim; i++) {
      if (succvec[i]>0)
        for (j=0; j<nocov; j++) {
          sumtemp[j]  += bhatvarmat[i][j];
          meantemp[j] += bhatmat[i][j];
        }
    }
    for (i=0; i<*pnsim; i++) {
      if (succvec[i]>0)
        for (j=0; j<nocov; j++)
          vartemp[j] += SQR(bhatmat[i][j] - (meantemp[j]/((double) nconv)));
    }
    for (j=0; j<nocov; j++) {
      varbhat[j]       = vartemp[j]/((double) nconv - 1);
      meanfishervar[j] = sumtemp[j]/((double) nconv);
    }
  } else if (nconv==1) {
    for (i=0; i<*pnsim; i++) {
      if (succvec[i]>0)
        for (j=0; j<nocov; j++) {
          varbhat[j]       = bhatvarmat[i][j];
          meanfishervar[j] = bhatmat[i][j];
        }
    }
  } else {
    printf("OBS: non of the surfaces converged\n");
  }

  if (nocov>0) {
    free_dmatrix(bhatmat);
    free_dmatrix(bhatvarmat);
    free_dvector(sumtemp);
    free_dvector(meantemp);
    free_dvector(vartemp);
  }
  cleanupbetamcmc();

  return;
}
