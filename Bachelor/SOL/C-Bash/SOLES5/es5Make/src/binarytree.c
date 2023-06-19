#include <stdio.h>
#include <stdlib.h>

#include <utils.h>
#include <binarytree.h>

node_t *buildTree(data_t *elem, node_t *t) {
    if (t == NULL) { // albero vuoto
	CHECK_PTR_RETURN((t = (node_t*)malloc(sizeof(node_t))),
			 "malloc", NULL);
	t->data  = elem;	
	t->left  = NULL;
	t->right = NULL;
    } else {
	if (elem->id < t->data->id) // elemento minore della radice
	    t->left  = buildTree(elem, t->left); // percorro il sottoalbero sinistro 
	else 
	    t->right = buildTree(elem, t->right); // percorro il sottoalbero destro
    }
    return t;
}

void deleteTree(node_t *t, void (*F)(void*)) {
    if (t != NULL) {
	deleteTree(t->left, F);
	deleteTree(t->right, F);
	if (F) F(t->data);
	free(t);
    }
}

// si suppone che t != NULL, il controllo va fatto prima
// della chiamata a getMin
data_t *getMin(node_t *t) {
    if (t->left==NULL)  // albero di sinistra vuoto
	return t->data;	// il minimo e' la radice
    return getMin(t->left);	
}

// si suppone che t != NULL, il controllo va fatto prima
// della chiamata a getMax
data_t *getMax(node_t *t) {
    if (t->right == NULL) // albero di destra vuoto
	return t->data;   // il massimo e' la radice
    return getMax(t->right);
}

void printInOrder(node_t *t, FILE *stream) {
    if (t != NULL) {
	printInOrder(t->left, stream);
	fprintf(stream, "%ld ", t->data->id);
	printInOrder(t->right, stream);
    }
}

data_t *searchId(long id, node_t *root) {
    node_t *n = root;
    while(n != NULL && n->data->id != id) {
	if (id < n->data->id) n = n->left;
	else n = n->right;
    }
    return n?n->data:NULL;
}


data_t *removeId(long id, node_t **root, void (*F)(void*)) {
    if (*root == NULL) return NULL;

    if ((*root)->data->id == id) {
	if ((*root)->left == NULL && (*root)->right == NULL) {
	    data_t *d = (*root)->data;
	    if (F) F(*root);
	    *root = NULL;
	    return d;
	}
	if ((*root)->right == NULL) {
	    data_t *d = (*root)->data;
	    node_t *tmp = (*root)->left;
	    if (F) F(*root);
	    *root = tmp;
	    return d;
	} else if ((*root)->left == NULL) {
	    data_t *d = (*root)->data;
	    node_t *tmp = (*root)->right;
	    if (F) F(*root);
	    *root = tmp;
	    return d;
	}
	/* il minimo di destra sostituisce il nodo corrente */

	data_t *min   = getMin((*root)->right);
	int   oldid   =	(*root)->data->id;
	void *olddata = (*root)->data->data;
	(*root)->data->id   = min->id;
	(*root)->data->data = min->data;
	data_t *d = removeId(min->id, &(*root)->right, F); // rimuoviamo il duplicato che si e' formato
	d->id   = oldid;
	d->data = olddata;
	return d;	    
    }
    data_t *d = NULL;
    if (id < (*root)->data->id)
	d = removeId(id, &(*root)->left, F);
    else 
	d = removeId(id, &(*root)->right, F);
    return d;
}

