#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>


int main(int argc, char const *argv[])
{   
    if (argc!=2) { printf("NOT 2 ARGOUMENTS\n"); exit(EXIT_FAILURE);}
    int pid,status;
    if((pid=fork())==0) execl("/bin/sleep","sleep",argv[1],(char*)NULL);
    else {
        waitpid(pid,&status,0);
        if (WIFEXITED(status)) { 
        printf("PID PROCESSO: %d\n",getpid());
        printf("PPID PADRE: %d\n",getppid());
        }
        else printf("stato %d\n", WEXITSTATUS(status));
    }

    return 0;
}
