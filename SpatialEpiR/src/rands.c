#include <S.h>


ranstart_()
{
  //  S_EVALUATOR
  seed_in((long *)NULL);
}

ranstop_()
{
  //  S_EVALUATOR
  seed_out((long *)NULL);
}

dranget_(dd)
double *dd;
{
  *dd=(double) unif_rand();
}

