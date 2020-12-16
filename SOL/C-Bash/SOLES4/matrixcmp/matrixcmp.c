#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int confronta(int (*comp) (const void*,const void*,size_t),float *M1, float *M2, int N)
{
    return comp(M1,M2,N);
}


int main(int argc, char const *argv[])
{
    int N=10;
    FILE *fb, *ftxt;
    float *M1 = malloc(N*N*sizeof(float));
    float *M2 = malloc(N*N*sizeof(float));
     
     fb = fopen("matrix.dat","r"); if (fb==NULL) {perror("Errore apertura file dat"); exit(1);}
     fread(M1,sizeof(float),N*N,fb);
     fclose(fb);
    
    ftxt = fopen("matrix.txt","r"); if (ftxt==NULL) {perror("Errore apertura file txt"); exit(1);}
    for(size_t i=0;i<N;++i) for(size_t j=0;j<N;++j) fscanf(ftxt, "%f ", &M2[N*i+j]);
    fclose(ftxt);

    printf("%d\n",confronta(memcmp,M1,M2,N*N));
    

    


    return 0;
}
