#include <stdio.h>
#include <stdlib.h>

#define dimN 16
#define dimM  8
#define CHECK_PTR(matrice,string) if(matrice==NULL) { perror(string); exit(EXIT_FAILURE);}
#define PRINTMAT(m,dimN,dimM) for(size_t i=0;i<dimN;++i) { for(size_t j=0;j<dimM;++j) printf("%ld \t",ELEM(m,i,j)); printf("\n");}
#define ELEM(m,i,j) m[dimM*i+j]


int main() {
    long *M = malloc(dimN*dimM*sizeof(long));
    CHECK_PTR(M, "malloc"); 
    for(size_t i=0;i<dimN;++i)
	for(size_t j=0;j<dimM;++j)			
	    ELEM(M,i,j) = i+j;    
    PRINTMAT(M, dimN, dimM);
    free(M);
    return 0;
}
