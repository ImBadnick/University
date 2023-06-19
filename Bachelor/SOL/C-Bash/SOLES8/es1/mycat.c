#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


#define BUFFERSIZE 256
#define errmeno1(s,m) if ( (s) == -1 ) {perror(m); exit(EXIT_FAILURE);}
#define errnull(s,m) if((s)==NULL) {perror(m); exit(EXIT_FAILURE);}


int main(int argc, char const *argv[])
{
    int lung;
    char * buffer;
    int fdr,fdw;

    if (argc<3) { perror("NEEDS 2 or more argouments"); exit(EXIT_FAILURE); }
    errmeno1(fdw=open(argv[1], O_WRONLY|O_CREAT|O_APPEND,0666),"writefile");
    errnull(buffer=malloc(sizeof(char)*BUFFERSIZE),"mallocbuffer");

    for (int i=2;i<argc;i++) 
    {
        errmeno1(fdr=open(argv[i],O_RDONLY),"readfile");
        while((lung=read(fdr,buffer,BUFFERSIZE))>0)
        {
            errmeno1(write(fdw,buffer,strlen(buffer)),"writing")
        }
        errmeno1(lung,"lettura");
        errmeno1(close(fdr),"closeFDR");
    }
    
    errmeno1(close(fdw),"closeFDW");

    return 0;
}
