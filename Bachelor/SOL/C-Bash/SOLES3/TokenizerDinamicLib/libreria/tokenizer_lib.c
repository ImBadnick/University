#define _POSIX_C_SOURCE  200112L
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// tokenizzazione di stringhe con strtok

// *************************************************************
// WARNING: strtok non e' rientrante leggere bene il manuale !!
// *************************************************************
void tokenizer(char *stringa, FILE *out) {
    char* token = strtok(stringa, " ");
    while (token) {
	fprintf(out, "%s\n", token);
	token = strtok(NULL, " ");
    }
}

// tokenizzazione di stringhe con strtok_r

void tokenizer_r(char *stringa, FILE *out) {
    char *tmpstr;
    char *token = strtok_r(stringa, " ", &tmpstr);
    while (token) {
	fprintf(out, "%s\n", token);
	token = strtok_r(NULL, " ", &tmpstr);
    }
}