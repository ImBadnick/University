#define _POSIX_C_SOURCE  200112L
#include "tokenizer.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
    if (argc!=2) {printf("Inserire 1 argomento"); return 0;}
    FILE* fout=fopen("out.txt","w");
    tokenizer_r((char*) argv[1],fout);
    return 0;
}
