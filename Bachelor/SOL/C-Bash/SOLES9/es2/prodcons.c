#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

#define true 1

int buffer[1];

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER; 
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

static void* produttore (void*arg) 
{
    int i=0;
    while(true) {
    pthread_mutex_lock(&mtx);
    while(buffer[0]!=0) 
    { 
        pthread_cond_wait(&cond, &mtx);
        printf("Produttore Waken up!\n"); fflush(stdout);
    }
    buffer[0]=i;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mtx);
    i++;
    }
    return (void*)0;
}

static void* consumatore (void*arg) 
{
    int p;
    while(true) {
    pthread_mutex_lock(&mtx);
    while(buffer[0]==0) 
    { 
        pthread_cond_wait(&cond, &mtx);
        printf("Consumatore Waken up!\n"); fflush(stdout);
    }
    p=buffer[0];
    buffer[0]=0;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mtx);
    printf("Consumato: %d\n",p);
    fflush(stdout);
    }
    return (void*)0;
}




int main(int argc, char const *argv[])
{
    buffer[0]=0;
    int status;
    pthread_t tid1,tid2;
    int err;
    if (( err=pthread_create(&tid1, NULL, &produttore, NULL) ) != 0 ) { /* gest errore */ }
    if (( err=pthread_create(&tid2, NULL, &consumatore, NULL) ) != 0 ) { /* gest errore */ }
    pthread_join(tid1,&status);
    pthread_join(tid2,&status);
    return 0;
}
