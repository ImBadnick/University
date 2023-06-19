#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>
#include <sys/syscall.h>
#include <string.h>
#include <limits.h>

#define NUMTHREADS 10

int buffer[1];

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t attesaFilosofo[NUMTHREADS];

int stato[NUMTHREADS]; // 0=fame 1=mangia 2=pensa

typedef struct
{
    int       i;
    pid_t     pid;   // linux pid
    pid_t     tid;   // linux thread id
    pthread_t ptid;  // pthreads tid    
} data;

void spawnThreads(unsigned int numthreads);

int mod(int a, int b)
{
    int r = a % b;
    return r < 0 ? r + b : r;
}

void *filosofi(void *args)
{
    struct timespec delay;
    int msec = (int)(((double)random() / INT_MAX) * 1000);
    delay.tv_sec = 0;
    delay.tv_nsec = 1000000 * msec;
    data *dp = (data *) args;
    for (int k=0;k<100;k++)
    {
        pthread_mutex_lock(&mtx);

        stato[dp->i]=0;
        while ((stato[mod((dp->i)-1,NUMTHREADS)]==1) || (stato[mod((dp->i)+1,NUMTHREADS)]==1)) {printf("%d: Aspetto le posate\n", dp->i); fflush(stdout); pthread_cond_wait(&attesaFilosofo[dp->i], &mtx);}
        printf("%d: Mangio (Mangiato %d volte) \n",dp->i, k); fflush(stdout);
        stato[dp->i]=1;
        pthread_mutex_unlock(&mtx);

        if(nanosleep(&delay, NULL) == -1) 
        {
            perror("nanosleep");
        }
        
        pthread_mutex_lock(&mtx);
        stato[dp->i]=2;
        printf("%d:Penso\n",dp->i); fflush(stdout);
         if(nanosleep(&delay, NULL) == -1) 
        {
            perror("nanosleep");
        }
        if ((stato[mod((dp->i)-1,NUMTHREADS)]==0) && (stato[mod((dp->i)-2,NUMTHREADS)]!=1))
        {
            stato[mod((dp->i)-1,NUMTHREADS)]=1;
            pthread_cond_signal(&attesaFilosofo[mod((dp->i)-1,NUMTHREADS)]);
        }

        if ((stato[mod((dp->i)+1,NUMTHREADS)]==0) && (stato[mod((dp->i)+2,NUMTHREADS)]!=1))
        {
            stato[mod((dp->i)+1,NUMTHREADS)]=1;
            pthread_cond_signal(&attesaFilosofo[mod((dp->i)+1,NUMTHREADS)]);
        }

        pthread_mutex_unlock(&mtx);

       
    }

    dp->pid  = getpid();
    dp->tid  = syscall(SYS_gettid);
    dp->ptid = pthread_self();
    printf("\n");
    return(dp);
}



int main(int argc, char const *argv[])
{
    for (int k=0;k<NUMTHREADS;k++) pthread_cond_init(&attesaFilosofo[k],NULL);
    spawnThreads(NUMTHREADS);
    return 0;
}



void spawnThreads(unsigned int numthreads)
{
    int ret[NUMTHREADS];
    data *status[NUMTHREADS];
    pthread_t *tids = malloc(sizeof(pthread_t) * numthreads); //Allocate memory for n threads

    int i;

    for (i = 0; i < numthreads; i++)
    {
        //Alloco la struttura dati per contenere le info dei threads
        data *dp = malloc(sizeof(data) * numthreads);
        memset(dp, '\0', sizeof(*dp));

        dp->i = i;

        ret[i] = pthread_create(&tids[i], NULL, filosofi, (void *) dp);

        if ( ret[i] != 0)
            perror("pthread create error");
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
