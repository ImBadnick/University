#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>


int main(int argc, char const *argv[])
{   
    if (argc!=2) { printf("NOT 2 ARGOUMENTS\n"); exit(EXIT_FAILURE);}
    int pid,status;

    for (int i=0;i<atoi(argv[1]);i++) 
    {
        pid=fork();
        if (pid==0) exit(0);
    }

    if (pid>0) sleep(20);

    return 0;
}
