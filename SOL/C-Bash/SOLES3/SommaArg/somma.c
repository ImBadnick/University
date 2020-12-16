#include <stdlib.h>
#include <stdio.h>

int somma(int x)
{
    int static sum=0;
    sum+=x;
    return sum;
}

int main(int argc, char const *argv[])
{
    if (argc!=2) { perror("Too many arguments"); exit(EXIT_SUCCESS);}
    int s=somma(INIT_VALUE),x;
    for (int i=0;i<atoi(argv[1]);i++) {scanf("%d",&x); s=somma(x);}
    printf("La somma e':%d\n",s);

    return 0;
}


