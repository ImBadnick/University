#include <stdlib.h>
#include <stdio.h>
#include <utils.h>
#include <binarytree.h>


int main(int argc, char *argv[]) {
    if (argc == 1) {
	fprintf(stderr, "usa: %s id [ids]\n", argv[0]);
	return -1;
    }
    node_t *root = NULL;
    const long array_size = 10;

    data_t array[] = { {12, "ciao"}, {32, "mondo"}, {18,"hello"}, {-1,"pippo"}, 
		       {0, "paperino"}, {18, "qua"}, {5, "quo"}, {54, "pluto"}, {28, "topolino"}, {15,"qui"}  };
    
    for(long i=0; i<array_size; ++i)
	root = buildTree(&array[i], root);

#if defined(DEBUG)    
    printInOrder(root, stdout);
    printf("\n");
    printf("Min: %ld\n", (getMin(root))->id);
    printf("Max: %ld\n", (getMax(root))->id);
    for(int i=1;i<argc;++i) {
	data_t *d = searchId(atoi(argv[i]), root);
	if (d!=NULL) {
	    printf("%ld trovato %s\n", d->id, (char *)d->data);
	} else {
	    printf("%s non trovato\n", argv[i]);
	}
    }
#endif
    
    for(int i=1;i<argc;++i) {
	data_t *d = removeId(atoi(argv[i]), &root, free);
	if (d) {
	    printf("%ld %s rimosso\n", d->id, (char*)(d->data));
	} else
	    printf("%s non trovato\n", argv[i]);
    }
        
    printInOrder(root, stdout);
    printf("\n");

    deleteTree(root, NULL);

    return 0;
}
