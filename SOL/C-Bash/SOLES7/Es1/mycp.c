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
    int buffersize,lung;
    char * buffer;
    int fdr,fdw;
    //  printf("%d",argc);
    if (argc>4 || argc<3) { printf("Not the right amount of arguments\n"); exit(-1);}
    if (argc==4) buffersize=atoi(argv[3]);
    else buffersize=BUFFERSIZE;

    errnull(buffer=malloc(sizeof(char)*buffersize),"mallocbuffer");
    errmeno1(fdr=open(argv[1],O_RDONLY),"readfile");
    errmeno1(fdw=open(argv[2], O_WRONLY|O_CREAT|O_TRUNC,0666),"writefile");

    while((lung=read(fdr,buffer,buffersize))>0)
    {
        errmeno1(write(fdw,buffer,buffersize),"writing")
    }
    errmeno1(lung,"lettura");
    
    errmeno1(close(fdr),"closeFDR");
    errmeno1(close(fdw),"closeFDW");

    return 0;
}
