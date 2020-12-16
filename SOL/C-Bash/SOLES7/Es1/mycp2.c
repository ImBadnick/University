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
    FILE* fdr;
    FILE* fdw;
    //  printf("%d",argc);
    if (argc>4 || argc<3) { printf("Not the right amount of arguments\n"); exit(-1);}
    if (argc==4) buffersize=atoi(argv[3]);
    else buffersize=BUFFERSIZE;

    errnull(buffer=malloc(sizeof(char)*buffersize),"mallocbuffer");
    fdr=fopen(argv[1],"r");
    fdw=fopen(argv[2],"w");

    fread(buffer,sizeof(char*),buffersize,fdr);
    
    fwrite(buffer,sizeof(char*),buffersize,fdw);

    fclose(fdr);
    fclose(fdw);

    return 0;
}
