#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>



#define BUFFERSIZE 256
#define MAXARG 8
#define TRUE 1

int readcmd(int * argc, char **argv, int numarg)
{
    char buffer[BUFFERSIZE];
    char * string;

    fgets(buffer, BUFFERSIZE, stdin);
    string=strtok(buffer," \n");
    while (string!=NULL)
    {
            if ((*argc)+1>=MAXARG) {fprintf(stderr,"Too much argouments! MAX: %d\n",MAXARG-1); exit(EXIT_FAILURE);}
            argv[*argc]=malloc(sizeof(char)*(strlen(string)+1));
            strcpy(argv[*argc],string);
            (*argc)++;
            string=strtok(NULL," \n");
    }   
    argv[*argc]=NULL;
}

static void execute (int argc, char* argv []) 
{
    pid_t pid;
    int status;
    fflush(stdout);
    switch( pid = fork() ) 
    {
    case -1: /* padre errore */ 
        {
            perror("Cannot fork");
            break; 
        }
    case 0: /* figlio */ 
        {
            execvp (argv[0],argv);
            perror("Cannot exec");
            exit(EXIT_FAILURE); 
        }
    default: /* padre */ 
        {
            waitpid(pid,&status,0);
        }
    }
}

int cmdexit(char **argv) { if (strcmp(argv[0],"exit")==0) return 1; else return 0; }


int main(void)
{
    char * argv[MAXARG];
    int argc;

    while(TRUE)
    {
        argc=0;
        printf("INSERISCI COMANDO: ");
        if (readcmd(&argc,argv,MAXARG)!= -1) 
        {
            if (cmdexit(argv)) exit(EXIT_SUCCESS);
            execute(argc,argv); 
        }
        else fprintf(stderr,"invalid command!\n");
    }


    return 0;
}