/* This file contains the functions needed to sample randomly in a matched and an
   unmatched setting */

/* Remember to INITIALISE the random number generator, ran1, before these functions are used! */

#include <stdio.h>
#include <math.h>

#include "smacc.h"

int samplematch(double *p, int np) {

/* p is a normed probability vector
   np is the length of the p vector */

  double r, acc;
  int i;

  r   = ran1();  /* generates a random number in the interval ]0,1[ */
  acc = p[0];
  i   = 0;

  while ((r > acc) && (i<np-1))
    acc += p[++i];

  return(i);
}

void sampleunmatch(double *p, int np, int *select, int n) {

/* p is any probability vector
   np is the length of the p vector
   select is the vector of selected values between 0 and np-1. select is sorted in increasing order.
   n is the number of integers to be selected */

  double r, w, acc;
  int *chosen, i, j;

  chosen = ivector(np);

  w = 0;
  for (i=0; i<np; i++) {
    w += p[i];
    chosen[i] = 0;   /* nothing has been chosen */
  }

  for (j=0; j<n; j++) {
    r = ran1()*w;    /* generates a random number in the interval ]0,w[ */

    i = 0;
    while (chosen[i]==1) i++;
    acc = p[i];

    while (r>acc) {
      while (chosen[++i]==1);
      acc += p[i];
    }
    chosen[i] = 1;

    w -= p[i];
  }

  j=0;
  for (i=0; i<np; i++)
    if (chosen[i]==1) select[j++]=i;

  free_ivector(chosen);
}