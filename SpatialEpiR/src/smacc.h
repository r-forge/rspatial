/* smacc.h - header file for the Spatial MAtched Case-Control project */

#define SQR(x)    (x)*(x)
#define FMAX(A,B) ((A) > (B) ? (A) : (B))     /* used in lnsrch and newt */

/* Function defined in randomgen.c */
void initran1(long int seed);
double ran1();

/* Functions defined in smaccsample.c */
int samplematch(double *p, int np);
void sampleunmatch(double *p, int np, int *select, int n);


/* Function defined in keredgecor.c */
void keredgecor (double* h, double* polyx, double* polyy, long int* npoly, double* x, double* y, long int* npoints,
            long int* Ikernel, long int* rings, long int* denspts, double* edgevec, long int* seed);


/* Functions defined in allofree.c */
double **dmatrix(int nrow, int ncol);
void free_dmatrix(double **m);
double ***ppdvector(int n);
void free_ppdvector(double ***v);
double *dvector(int n);
void free_dvector(double *v);
int *ivector(int n);
void free_ivector(int *v);
long int *livector(int n);
void free_livector(long int *v);
long int **limatrix(int nrow, int ncol);
void free_limatrix(long int **m);

/* Functions defined in matfunc.c */
int ludcmp(double **a, int n, int *indx, double *d);
void lubksb(double **a, int n, int *indx, double *b);
void matinv(double **a, int n, double **y);
void matcopy(double **a, int nrow, int ncol, double **b);
void veccopy(double *a, int n, double *b);
void liveccopy(long int *a, int n, long int *b);
void rowcopy(double **a, int frow, int no, int ncol, double **b);
void matmult(double **a, double **b, int nrowa, int ncol, int ncolb, double **c);
void mattransmult(double **a, double **b, int nrow, int ncola, int ncolb, double **c);

/* Functions defined in newt.c */
void newt(double *x, int dimx, int *check, void (*vecfunc)(int, double [], double []));
void newt_an(double *x, int dimx, int *check, void (*vecfunc)(int, double [], double []),
             void (*vecfuncdif)(int, double *, double **) );
void dfpmin(double *p, int n, double gtol, int *iter, double *fret,
            double (*func)(int ,double *), void (*dfunc)(int, double *,double *));


/* Functions defined in smaccalc.c */
void smaccest(long int *cc_, double *covvec, double *x_, double *y_,
              long int *N_, long int *nocov_, long int *notup_, long int *sztup_,
              long int *matched_, double *hvals_, long int *nohvals_,
              long int *Iedge_, double *edgeoff_,
              double *cvvec, double *s_, double *beta, double *varbeta, double *w_, double *h_,
              long int *poutermax, long int *pinnermax, double *ptolbeta, double *ptolg);

void calcCV(double *x_, double *y_, long int *cc_, double *s_,
            double *w_, double *innerprod, double *hvals_,
            long int *Iedge_, double *edgeoff_,
            double *cvvec, long int *N_,
            long int *notup_, long int *sztup_, long int *matched_,
            long int *nohvals_, double *h_);

void mcmc(long int *pnsim, double *probvec, double *tvec, long int *succvec,
          double *xgrid, double *ygrid,
          long int *nx, long int *ny, long int *Ipoly, double *surfacevec, long int *cc_,
          double *covvec,
          double *x_, double *y_, long int *N_, long int *nocov_, long int *notup_,
          long int *sztup_, long int *pnocases, long int *matched_, double *h_,
          long int *Iedge_, double *edgeoff_,
          long int *poutermax, long int *pinnermax, double *ptolbeta, double *ptolg,
          long int *randomseed);

void betamcmc(long int *pnsim, long int *succvec, double *varbhat, double *meanfishervar,
              long int *cc_, double *covvec,
              double *x_, double *y_, long int *N_, long int *nocov_,
              long int *notup_, long int *sztup_, long int *pnocases,
              long int *matched_, double *h_, long int *Iedge_, double *edgeoff_,
              long int *poutermax, long int *pinnermax, double *ptolbeta,
              double *ptolg, long int *randomseed);

void ctest(long int *cc_, double *covvec, double *x_, double *y_,
              long int *N_, long int *nocov_, long int *notup_, long int *sztup_,
              long int *matched_, double *hvals_, long int *nohvals_,
              long int *Iedge_, double *edgeoff_,
              double *cvvec, double *s_, double *beta, double *w_, double *h_,
              long int *poutermax, long int *pinnermax, double *ptolbeta, double *ptolg);
