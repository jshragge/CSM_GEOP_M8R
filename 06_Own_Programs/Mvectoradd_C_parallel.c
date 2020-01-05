/* Perform vector addition: C = A+B */
 
#include <rsf.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
    int n1, i1, ntest;
    float *A, *B, *C;
    
    /* FOR OPENMP */
    int tid,nth;
    /* END OPENMP */
    
    sf_file in, out, other; /* Input,  output, and aux files */
 
    sf_init(argc,argv);  /* Initialize RSF */
    in = sf_input("in");  /* standard input - vector A*/
    other = sf_input("other"); /* auxillary file  - vector B */
    out = sf_output("out");  /* standard output - vector C */
    
    /* check that the input is float */
    if (SF_FLOAT != sf_gettype(in)) 	sf_error("Need float input");
 
    /* n1 is the fastest dimension (trace length) */
    if (!sf_histint(in,"n1",&n1))  sf_error("No n1= in input");
    if (!sf_histint(other,"n1",&ntest))  sf_error("No n1= in aux");
    if (ntest != n1 ) sf_error("Vector dimensions are incompatible");
	
    /* allocate floating point arrays */
    A = sf_floatalloc (n1);
    B = sf_floatalloc (n1);
    C = sf_floatalloc (n1);
  
    /*read a trace */
    sf_floatread(A,n1,in);
    sf_floatread(B,n1,other);
 
#pragma omp parallel shared(A,B,C,nth) private(i1,tid)
    {
	tid = omp_get_thread_num();
	if (tid == 0)
	{
	    nth = omp_get_num_threads();
	    printf("Number of threads = %d\n", nth);
	    printf("Number of threads = %d\n", nth);
	}
	printf("Thread %d starting...\n",tid);
	
#pragma omp for schedule(dynamic)
	for (i1=0; i1 < n1; i1++)
	{
	    C[i1] = A[i1] + B[i1];
	}
	
    }  /* end of parallel section */

 
    /* FOR OPENMP */ 
#pragma omp parallel shared(A,B,C) private(i1)
#pragma omp for schedule(dynamic)
    for (i1=0; i1 < n1; i1++) {
	C[i1]= A[i1]+B[i1];
    }
	
    /* write a trace */
	
    sf_floatwrite(C,n1,out);

    exit(0);
}
