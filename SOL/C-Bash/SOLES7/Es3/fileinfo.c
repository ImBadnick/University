#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <errno.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>


#define errmeno1(s,m) if ( (s) == -1 ) {perror(m); exit(EXIT_FAILURE);}
#define errnull(s,m) if((s)==NULL) {perror(m); exit(EXIT_FAILURE);}

int isdir(const char *path) {
    struct stat statbuf;
    if (stat(path, &statbuf) != 0) return 0;
    return S_ISDIR(statbuf.st_mode);
}

void printprotbit(struct stat d_stat){
            printf( (S_ISDIR(d_stat.st_mode)) ? "d" : "-");
            printf( (d_stat.st_mode & S_IRUSR) ? "r" : "-");
            printf( (d_stat.st_mode & S_IWUSR) ? "w" : "-");
            printf( (d_stat.st_mode & S_IXUSR) ? "x" : "-");
            printf( (d_stat.st_mode & S_IRGRP) ? "r" : "-");
            printf( (d_stat.st_mode & S_IWGRP) ? "w" : "-");
            printf( (d_stat.st_mode & S_IXGRP) ? "x" : "-");
            printf( (d_stat.st_mode & S_IROTH) ? "r" : "-");
            printf( (d_stat.st_mode & S_IWOTH) ? "w" : "-");
            printf( (d_stat.st_mode & S_IXOTH) ? "x" : "-");
            printf("\n");
}

int main(int argc, char const *argv[])
{
    int fdr;
    DIR *d;

    for (int i=1; i<argc; i++) 
    {
            struct stat info;
            errmeno1(stat(argv[i], &info),"StatsError");
            printf("NOME: %s\n",argv[i]);
            printf("NUMERO I-NODE: %ld\n",info.st_ino);
            if (isdir(argv[i])) printf("TIPO DI FILE: -d\n"); else printf("TIPO DI FILE: -f\n");
            printf("BIT DI PROTEZIONE: "); printprotbit(info);
            printf("USER ID: %d\n",getpwuid(info.st_uid)->pw_uid);
            printf("GROUP IDENTIFIER: %d\n",getgrgid(info.st_gid)->gr_gid);
            printf("SIZE: %ld\n", info.st_size);
            char date[20];
            strftime(date, 20, "%d-%m-%y", localtime(&(info.st_mtime)));
            printf("LAST MODIFY: %s\n",date);
            printf("\n\n");
    }
    return 0;
}
