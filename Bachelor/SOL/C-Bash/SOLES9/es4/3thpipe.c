#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>
#include <sys/syscall.h>
#include <string.h>
#include <limits.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <errno.h>


#define BUFFERSIZE 256
#define true 1

int buffer[1];

pthread_mutex_t pmtx = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond1;
pthread_cond_t cond2;
int scritto;

typedef struct
{
    int       i;
    pid_t     pid;   // linux pid
    pid_t     tid;   // linux thread id
    pthread_t ptid;  // pthreads tid    
} data;

typedef struct
{
    const char * file;
    data * data;
} argss;

void spawnThreads(int numthreads, const char * file);

void rfile(argss *args)
{
    int pfd;
    size_t buffersize=BUFFERSIZE;
    int read;
    data *dp = args->data;
    const char *file =  args->file;
    char * buffer = malloc(sizeof(char)*BUFFERSIZE);
    FILE * fp;
    if ((fp=fopen(file,"r")) == NULL) exit(EXIT_FAILURE);
    if (pfd=open("serverreq",O_WRONLY) == -1) {perror("OPEN PIPE ERROR: "); exit(EXIT_FAILURE);}
    while ((read = getline(&buffer, &buffersize, fp)) != -1) {
        pthread_mutex_lock(&pmtx);
        while (scritto==1) { printf("rfile dorme"); pthread_cond_wait(&cond1, &pmtx);}
        printf("rfile svegliato");
        write(pfd,buffer,BUFFERSIZE);
        scritto=1;
        pthread_cond_signal(&cond1);
        pthread_mutex_unlock(&pmtx);
    }

    dp->pid  = getpid();
    dp->tid  = syscall(SYS_gettid);
    dp->ptid = pthread_self();
    return(dp);

}

void tokenizer(argss *args)
{
    int pfd,l;
    data *dp = args->data;
    char *buf = malloc(BUFFERSIZE*sizeof(char));
    if ((mkfifo("serverreq",0664) == -1) && errno!=EEXIST) {perror("MKFIFO ERROR: "); exit(EXIT_FAILURE);}
    if (chmod("serverreq",0664) == -1) {perror("CHMOD ERROR: "); exit(EXIT_FAILURE);}
    
    /* apertura in lettura e scrittura */
    if (pfd=open("serverreq",O_RDWR) == -1) {perror("OPEN PIPE ERROR: "); exit(EXIT_FAILURE);}
    /* uso pipe: la read è bloccante anche senza client*/
    while (true) {
        pthread_mutex_lock(&pmtx);
        while (scritto==0) {printf("tokenizer dorme"); pthread_cond_wait(&cond1, &pmtx); }
        printf("tokenizer svegliato");
        if ( (l=read(pfd,buf,BUFFERSIZE)) == -1)
        {
            char* token = strtok(buf, " ");
            while (token) 
            {
            printf("token: %s\n", token);
            token = strtok(NULL, " ");
            }
        }
        else { break; }
        scritto=0;
        pthread_cond_signal(&cond1);
        pthread_mutex_unlock(&pmtx);
    }

    dp->pid  = getpid();
    dp->tid  = syscall(SYS_gettid);
    dp->ptid = pthread_self();
    return(dp);
}

void uniquewords(void *args)
{
    data *dp = (data *) args;

    dp->pid  = getpid();
    dp->tid  = syscall(SYS_gettid);
    dp->ptid = pthread_self();
    printf("\n");
    return(dp);
}

int main(int argc, char const *argv[])
{
    scritto=0;
    if (argc==2) spawnThreads(3,argv[1]);
    else { perror("Not 2 args"); exit(EXIT_FAILURE);}
    return 0;
}



void spawnThreads(int numthreads, const char * file)
{
    int ret[numthreads];
    data *status[numthreads];
    pthread_t *tids = malloc(sizeof(pthread_t) * numthreads); //Allocate memory for n threads

    int i;

    for (i = 0; i < numthreads; i++)
    {
        //Alloco la struttura dati per contenere le info dei threads
        data *dp = malloc(sizeof(data) * numthreads);
        memset(dp, '\0', sizeof(*dp));
        dp->i = i;
        switch (dp->i)
        {
        case 0: ;
            argss *args;
            args = malloc(sizeof(argss));
            args->data=dp;
            args->file=file;
            ret[i]=pthread_create(&tids[i], NULL, rfile, args); 
            if ( ret[i] != 0) perror("pthread create error");
            break;
        case 1: 
            ret[i]=pthread_create(&tids[i], NULL, tokenizer, args);
            if ( ret[i] != 0) perror("pthread create error");
            break;
        // case 2: 
        //     ret[i]=pthread_create(&tids[i], NULL, uniquewords, (void *) dp); 
        //     if ( ret[i] != 0) perror("pthread create error");
        //     break;

        // default: perror("ERRORE NEL PROGRAMMA"); exit(EXIT_FAILURE);
        //     break;
        } 
    }

    for (int i = 0; i < numthreads; ++i)
    {
        ret[i] = pthread_join(tids[i], (void *) &status[i]);
    }

    for (int i = 0; i < numthreads; ++i)
    {
        if ( ret[i] != 0)
            perror("pthread join error");
        else
        {
            printf("thread num %d joined and reports pthreadId of %lu "
                   "process pid of %d and linux tid of %d\n",
                   status[i]->i, status[i]->ptid, status[i]->pid, status[i]->tid);
            free(status[i]);
        }
    }
    free(tids);
}
