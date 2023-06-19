#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_CHAR 1000

int main(int argc, char const *argv[])
{
    FILE *psw;
    FILE *out=fopen("psw.txt","w");
    char str[MAX_CHAR];
    psw=fopen("/etc/passwd","r");
    if (psw == NULL) perror ("Error:");
    while(fgets(str,MAX_CHAR,psw) != NULL) 
    { for (int i=0;i<strchr(str,':')-str;i++) fprintf(out,"%c",str[i]); 
      fprintf(out,"\n");
    }
    
    return 0;
}
