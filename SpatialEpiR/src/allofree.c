/* allofree.cpp - routines to dynamically allocate and free objects */
/*                (taken from Numerical Recipes in C pp. 940)       */

#include <stdlib.h>
#include <stdio.h>

#define FREE_ARG char* 

// include this if not run by a makefile:
//#define notSplus 1

//#ifdef notSplus
//  #define myalloc(n,t) ((t*) malloc((size_t) ((n)*sizeof(t))) )
//  #define myfree free
//#else
#include <R.h>
#define myalloc(n,t) ((t*) Calloc((long int) n, t) )
#define myfree Free
//#endif


/* Allocate and free an array of doubles with subscript range [0..n-1] */
double *dvector(int n) {

    double *v;

    v=myalloc(n,double);
    /* v=(double *) malloc((size_t) (n*sizeof(double))); */
    if (!v) { printf("dvector: allocation error.\n"); return(NULL); }
    return(v);
}

void free_dvector(double *v) {
    /*myfree((FREE_ARG) (v));*/
    myfree(v);
}


/* Allocate and free a double matrix with subscript range [0..nrow-1][0..ncol-1] */
double **dmatrix(int nrow, int ncol) {

        int i;
        double **m;

        m = myalloc(nrow,double *);
        //m = (double **)       malloc((size_t)(nrow*sizeof(double *)));
        if (!m) { printf("dmatrix: type 1 allocation error.\n"); return(NULL); }

        m[0] = myalloc(nrow*ncol,double);
        //m[0] = (double *) malloc((size_t)(nrow*ncol*sizeof(double)));
        if (!m[0]) { printf("dmatrix: type 2 allocation error.\n"); return(NULL); }

        for (i=1; i<nrow; i++) m[i] = m[i-1]+ncol;

        return(m);
}

void free_dmatrix(double **m) {

        myfree((m[0]));
        myfree((m));
}


/* Allocate and free an array of integers with subscript range [0..n-1] */
int *ivector(int n) {

    int *v;

    v = myalloc(n,int);
    //v=(int *) malloc((size_t) (n*sizeof(int)));
    if (!v) { printf("ivector: allocation error.\n"); return(NULL); }
    return(v);
}

void free_ivector(int *v) {
    myfree((v));
}

/* Allocate and free an array of long integers with subscript range [0..n-1] */
long int *livector(int n) {

    long int *v;

    v = myalloc(n,long int);
    //v=(long int *) malloc((size_t) (n*sizeof(long int)));
    if (!v) { printf("livector: allocation error.\n"); return(NULL); }
    return(v);
}

void free_livector(long int *v) {
    myfree((v));
}

/* Allocate and free a double matrix with subscript range [0..nrow-1][0..ncol-1] */
long int **limatrix(int nrow, int ncol) {

        int i;
        long int **m;

        m = myalloc(nrow,long int *);
        if (!m) { printf("limatrix: type 1 allocation error.\n"); return(NULL); }

        m[0] = myalloc(nrow*ncol,long int);
        if (!m[0]) { printf("limatrix: type 2 allocation error.\n"); return(NULL); }

        for (i=1; i<nrow; i++) m[i] = m[i-1]+ncol;

        return(m);
}

void free_limatrix(long int **m) {

        myfree((m[0]));
        myfree((m));
}

/* Allocate and free an array of doubles** with subscript range [0..n-1] */
double ***ppdvector(int n) {

        double ***v;

        v = myalloc(n,double **);
        //v=(double ***) malloc((size_t) (n*sizeof(double **)));
        if (!v) { printf("ppdvector: allocation error.\n"); return(NULL); }
        return(v);
}

void free_ppdvector(double ***v) {
        myfree((v));
}
