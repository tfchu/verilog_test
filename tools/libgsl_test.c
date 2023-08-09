#include <stdio.h>
#include <gsl/gsl_sf_bessel.h>

int
main (void)
{
    double x = 15.0;
    double y = gsl_sf_bessel_J0 (x);
    printf ("J0(%g) = %.18e/n", x, y);
    return 0;
}

// compile (change to correct path)
//gcc -Wall -I/home/yourname/gsl/include -c example.c
//gcc -L/home/yourname/gsl/lib example.o -lgsl -lgslcblas -lm
// run
// ./a.out