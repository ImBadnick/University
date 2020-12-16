#include <stdlib.h>
#include <stdio.h>
#include <string.h>


int main(int argc, char const *argv[]) 
{
    int N=10;
    float *M = malloc(N*N*sizeof(float));
    for(size_t i=0;i<N;++i) for(size_t j=0;j<N;++j)	M[N*i+j]=i+j;
    FILE *fb, *ftxt;
    
    fb = fopen("matrix.dat","w"); if (fb==NULL) {perror("Errore apertura file dat"); exit(1);}
    fwrite(M,sizeof(float),N*N,fb);
    fclose(fb);

    ftxt = fopen("matrix.txt", "w"); if (ftxt==NULL) {perror("Errore apertura file txt"); exit(1);}
    for(size_t i=0;i<N;++i) { for(size_t j=0;j<N;++j) fprintf(ftxt, "%f ", M[N*i+j]); fprintf(ftxt, "\n"); }
    fclose(ftxt);

    return 0;
}
