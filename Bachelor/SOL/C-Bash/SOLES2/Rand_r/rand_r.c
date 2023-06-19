#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define N 1000
#define K 20


int main(int argc, char const *argv[])
{
    int occ[K];
    int i,number;
    unsigned int save=time(NULL);
    for (i=0;i<K;i++) occ[i]=0;
    for (i=0;i<N;i++) 
    {   
        number=rand_r(&save)%K;
        occ[number]+=1;
    }
    for (i=0;i<K;i++) printf("%d ",occ[i]);
    printf("\n");
    for (i=0;i<K;i++) printf("%d : %.2f%%\n",i,(float) (occ[i]*100)/N);
    printf("\n");

    return 0;
}