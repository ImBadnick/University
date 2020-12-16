#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 
#define REALLOC_INC 16
#define RIALLOCA(buf, newsize) \
        buf=realloc(buf,newsize)

char* mystrcat(char *buf, size_t sz, char *first, ...) {
    char *tmp;
    int dispspace=sz;
    va_list argfun; //Creo la lista di parametri variabili
    va_start(argfun,first); //La inizializzo
    if (dispspace<strlen(first)) { sz+=strlen(first); RIALLOCA(buf,sz); } else dispspace-=strlen(first); //Alloco spazio per il primo elemento
    strcat(buf,first); //Concateno il primo elemento
    
    while((tmp=va_arg(argfun,char*))!=NULL) //Faccio un ciclo per allocare tutti i parametri variabili
        {   
            if (dispspace<strlen(tmp)) //Controllo se lo spazio disponibile basta per contenere la stringa e nel caso non potesse rialloco lo spazio del buffer
            {
                sz=sz+strlen(tmp);
                RIALLOCA(buf,sz);
            }
            else dispspace-=strlen(tmp);
            strcat(buf,tmp); //Concateno la stringa al buffer
        }
    va_end(argfun); //Elimino la lista di parametri 
    return buf; //Ritorno il buffer
}  
 
int main(int argc, char *argv[]) {
  if (argc != 7) { printf("troppi pochi argomenti\n"); return -1; }
  char *buffer=NULL;
  RIALLOCA(buffer, REALLOC_INC);  // macro che effettua l'allocazione
  buffer[0]='\0';
  buffer = mystrcat(buffer, REALLOC_INC, argv[1], argv[2], argv[3], argv[4], argv[5], argv[6], NULL);
  printf("%s\n", buffer);     
  free(buffer);
  return 0;
}