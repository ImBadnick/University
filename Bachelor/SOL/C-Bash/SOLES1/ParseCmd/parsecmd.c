#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int verifystring(char* string)
{
    int i=0,start;
    while(string[i]=='-') i++;
    if (string[i]=='n') { i++; start=i; while(i<strlen(string)) {if (string[i]>='0' && string[i]<='9') i++; else return -1;} return start;}
    if (string[i]=='s') {i++; return i;}
    if (string[i]=='m') { i++; start=i; while(i<strlen(string)) {if (string[i]>='0' && string[i]<='9') i++; else return -1;} return start;}
}

int verify(char* string)
{
    int i=0;
    while(string[i]=='-') i++;
    if (string[i]=='n') return 1;
    if (string[i]=='s') return 2;
    if (string[i]=='m') return 3;
    return -1;
}

char search(char* string)
{
    int i=0;
    while(string[i]=='-') i++;
    return string[i];
} 


int main(int argc, char const *argv[])
{
    int i,j,ver,verstring;
    char *tmp;
    if (argc < 2) fprintf(stderr,"Not enough arguments");
    for (i=1;i<argc;i++) if (strcmp(argv[i],"-h")==0) { printf("Help: nome-programma -n <numero> -s <stringa> -m <numero> -h\n"); return 0;}

    for(i=1;i<argc;i++)
    {
        ver=verify((char*)argv[i]);
        verstring=verifystring((char*)argv[i]);
        tmp=(char*) argv[i];
        if (verstring==-1) {printf("ERRORE NELL'INSERIMENTO DEGLI ARGOMENTI\n"); return 0;}
        if (ver==1 || ver==2 || ver==3)
            {
                if(ver==1) 
                {
                     if ((verstring-strlen(argv[i]))==0) //Formato del tipo ----n 10 o -n 20
                        {
                            if (i+1==argc) { fprintf(stderr,"Errore in -n | "); return 0;}
                            if (strcmp(argv[i+1],"-s")==0 || strcmp(argv[i+1],"-m")==0 || strcmp(argv[i+1],"-n")==0) { fprintf(stderr,"Errore in -n | "); return 0;}
                            else { i++; printf("-n: %d | ", atoi(argv[i]));}
                        }
                     else { printf("-n: "); tmp=(char*) argv[i]; for(j=verstring;j<strlen(argv[i]);j++) printf("%c",tmp[j]); printf(" | ");} //Formato del tipo -n10 ---n20
                }

                if(ver==2) 
                {
                    if((verstring-strlen(argv[i]))==0) //Formato del tipo -s 20 o -------s 20
                        {
                            if (i+1==argc) { fprintf(stderr,"Errore in -s | "); return 0;} 
                            else { i++; printf("-s: %s | ", argv[i]);}
                        }
                    else { printf("-s: "); tmp=(char*) argv[i]; for(j=verstring;j<strlen(argv[i]);j++) printf("%c",tmp[j]); printf(" | ");}
                    
                }
                
                if(ver==3)
                {
                     if ((verstring-strlen(argv[i]))==0) //Formato del tipo ----n 10 o -n 20
                        {
                            if (i+1==argc) { fprintf(stderr,"Errore in -m | "); return 0;}
                            if (strcmp(argv[i+1],"-s")==0 || strcmp(argv[i+1],"-m")==0 || strcmp(argv[i+1],"-n")==0) { fprintf(stderr,"Errore in -m | "); return 0;}
                            else { i++; printf("-m: %d | ", atoi(argv[i]));}
                        }
                     else { printf("-m: "); tmp=(char*) argv[i]; for(j=verstring;j<strlen(argv[i]);j++) printf("%c",tmp[j]); printf(" | ");} //Formato del tipo -n10 ---n20
                }


            }

        else if (ver!=1 && ver!=2 && ver!=3 && tmp[0]=='-') printf("Operazione -%c non riconosciuta | ",search(tmp));

    }
    printf("\n");
}
