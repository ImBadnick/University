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


void findfile(char *dir, const char *filename,char *olddir)
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

    while ((errno = 0, file = readdir(d))!=NULL) {
        if (file->d_type == DT_DIR)
        {   
            if(!(strcmp(file->d_name,".") == 0 || strcmp(file->d_name,"..")==0))
                {  
                    errnull(getcwd(current,BUFFER_SIZE),"GETCWD ERROR");
                    findfile(file->d_name,filename,current);
                }
        }
        else if (strcmp(file->d_name,filename)==0) 
        { 
            struct stat attrib;
            errnull(getcwd(buf,BUFFER_SIZE),"GETCWD ERROR");
            stat(file->d_name, &attrib);
            char date[20];
            strftime(date, 20, "%d-%m-%y", localtime(&(attrib.st_ctime)));
            printf("%s: %s --> Ultima modifica: %s \n",buf,filename,date);
        }
        
    }
    errmeno1(closedir(d),"closedir");
    if(strcmp(olddir,"NULL")!=0) chdir(olddir);
    return;

}

int main(int argc, char const *argv[])
{
    findfile(".",argv[1],"NULL");

    return 0;
}
