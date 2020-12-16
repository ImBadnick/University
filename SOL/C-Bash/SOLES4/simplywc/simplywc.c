#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>

#define MAX 1000

int countwords(char * file)
{
    FILE *f = fopen(file,"r");
    if (f==NULL) {perror("Errore nell'apertura del file"); exit(1);}
    int sum=0;
    char prevch = '\0',ch;
     while((ch = fgetc(f)) != EOF)
    {
        if (prevch == '\0' || isspace(prevch)) sum++;
        prevch = ch;  
    }
    fclose(f);
    return sum;
}

int countnewlines(char *file)
{
    FILE *f = fopen(file,"r");
    if (f==NULL) {perror("Errore nell'apertura del file"); exit(1);}
    int sum=0;
    char prevch = '\0',ch;
     while((ch = fgetc(f)) != EOF)
    {
        if(isspace(ch))
        {
            if (ch == '\n')
                sum++;
        }
        prevch = ch;  
    }
    fclose(f);
    return sum;
}



int main(int argc, char *argv[])
{
    if(argc<2) {printf("Troppi pochi argomenti! \n"); return 0;}
    int lflag=0,wflag=0,c, nwords=0, nnewlines=0;
    int otherflags=0;
    while((c=getopt(argc, argv, "wl"))!= -1)
    switch (c) {
        case 'l': lflag = 1; break;        
        case 'w': wflag = 1; break;
        default: otherflags++;
    }
    if(otherflags!=0) {printf("Argomenti non validi o ripetuti. \n"); return 0;}

    if (lflag == 1 && wflag == 1) { for (int i=3;i<argc;i++) { nwords+=countwords(argv[i]); nnewlines+=countnewlines(argv[i]);} printf("words: %d ",nwords); printf("newlines: %d\n",nnewlines);}
    if (lflag == 1 && wflag == 0) { for (int i=2;i<argc;i++) nnewlines+=countnewlines(argv[i]); printf("newlines: %d\n", nnewlines);}
    if (lflag == 0 && wflag == 1) { for (int i=2;i<argc;i++) nwords+=countwords(argv[i]); printf("words: %d\n",nwords);}
    if (lflag == 0 && wflag == 0) { for (int i=1;i<argc;i++) { nwords+=countwords(argv[i]); nnewlines+=countnewlines(argv[i]);} printf("words: %d ",nwords); printf("newlines: %d\n",nnewlines);}

    return 0;
}
