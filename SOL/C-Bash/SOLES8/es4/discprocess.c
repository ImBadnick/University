#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

void creaprocessi(int n)
{
    int pid,status;
    if (n==-1) return;
    for (int j=0;j<n;j++) printf("-");
    if (n!=0) printf(" %d: Creo un processo figlio\n",getpid());
    else printf(" %d: sono l'ultimo discendente\n",getpid());
    fflush(stdout);
    if (n!=0) pid=fork();
    if (pid>0 || n==0) 
    { 
      waitpid(pid,status,0);
      for (int j=0;j<n;j++) printf("-");
      printf(" %d: Terminato con successo\n",getpid());
      fflush(stdout);
      exit(0);
    }
    if (pid==0) creaprocessi(n-1);
}


int main(int argc, char const *argv[])
{   
    if (argc!=2) { printf("NOT 2 ARGOUMENTS\n"); exit(EXIT_FAILURE);}
    if (atoi(argv[1])<=1) { printf("Number less then 1"); exit(EXIT_FAILURE);}
    creaprocessi(atoi(argv[1]));    
    return 0;
}
