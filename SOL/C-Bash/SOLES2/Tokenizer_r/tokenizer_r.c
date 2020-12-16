#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
	fprintf(stderr, "use: %s stringa1 stringa2\n", argv[0]);
	return -1;
    }
    char *save1=NULL;
    char *save2=NULL;
    char* token1 = strtok_r(argv[1], " ",&save1);
    while (token1) {
	printf("%s\n", token1);
	char* token2 = strtok_r(argv[2], " ",&save2);
	while(token2) {
	    printf("%s\n", token2);
	    token2 = strtok_r(NULL, " ",&save2);
	}
	token1 = strtok_r(NULL, " ",&save1);
    }
    return 0;
}