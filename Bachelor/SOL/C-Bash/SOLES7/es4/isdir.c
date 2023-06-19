#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <errno.h>
#include <time.h>

#define errmeno1(s,m) if ( (s) == -1 ) {perror(m); exit(EXIT_FAILURE);}
#define errnull(s,m) if((s)==NULL) {perror(m); exit(EXIT_FAILURE);}

#define BUFFER_SIZE 1024

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

void isdir(char *dir, const char *filename,char *olddir)
{   
    DIR *d;
    struct dirent* file;
    char buf[BUFFER_SIZE];
    char current[BUFFER_SIZE];

    if (strcmp(dir,".")==0) 
    {
        errnull(d=opendir(dir),dir);
    }
    else
    {
            errmeno1(chdir(dir),"movingIntoDirectory");
            errnull(d=opendir("."),"opendir");
    }

    printf("Directory: %s\n",dir);
    while ((errno = 0, file = readdir(d))!=NULL) 
    {   
        if (file->d_type!=DT_DIR)
        {
            struct stat fstats;
            stat(file->d_name,&fstats);
            printf("%s %ld ",file->d_name,fstats.st_size);
            printprotbit(fstats);
        }   
    }
    printf("--------------------\n");
    errmeno1(closedir(d),"closedir");

    errnull(d=opendir("."),"opendir");

    while ((errno = 0, file = readdir(d))!=NULL) {
        if (file->d_type == DT_DIR)
        {   
            if(!(strcmp(file->d_name,".") == 0 || strcmp(file->d_name,"..")==0))
                {  
                    errnull(getcwd(current,BUFFER_SIZE),"GETCWD ERROR");
                    isdir(file->d_name,filename,current);
                }
        }
    }

    errmeno1(closedir(d),"closedir");
    if(strcmp(olddir,"NULL")!=0) chdir(olddir);
    return;

}

int main(int argc, char const *argv[])
{
    isdir(".",argv[1],"NULL");

    return 0;
}
