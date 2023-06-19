#if !defined(BINARYTREE_H_)
#define BINARYTREE_H_

#include <stdio.h>

/// elemento base di un nodo
typedef struct data_t {
    long id;
    void *data;
} data_t;

/// struttura nodo dell'albero
typedef struct node_t {
    data_t        *data;
    struct node_t *left; 
    struct node_t *right;
} node_t;

/**
   \brief Inserisce un elemento nell'albero.
   \param elem elemento da inserire
   \param root radice dell'albero (se NULL viene costruito il nodo radice)
   \return radice dell'albero
*/
node_t *buildTree(data_t *elem, node_t *root);

/**
   \brief Dealloca un albero binario di ricerca. 
   \param root radice dell'albero
   \param F    funzione per deallocare l'elemento dati del nodo
 */ 
void deleteTree(node_t *root, void (*F)(void*));

/**
   \brief Restituisce l'elemento minimo nell'albero.
   \param t nodo radice a partire dal quale viene cercato il minimo elemento
   \return  dato associato al nodo minimo

   Si suppone che t sia diverso da NULL.
 */
data_t *getMin(node_t *t);

/**
   \brief Restituisce l'elemento massimo. 
   \param t nodo radice a partire dal quale viene cercato il massimo elemento
   \return  dato associato al nodo massimo

   Si suppone che t sia diverso da NULL.
 */
data_t *getMax(node_t *t);

/**
   \brief Stampa i nodi dell'albero facendo una visita ordinata
   \param t nodo radice a partire dal quale viene fatta la stampa in ordine
   \param stream FILE pointer associato allo stream di output
*/
void printInOrder(node_t *t, FILE *stream);

/**
   \brief Cerca un identificatore nell'albero
   \param id  identificatore da cercare nell'albero
   \param root nodo radice dell'albero
   \return dato assocato all'id oppure NULL se l'elemento non e' stato trovato
*/
data_t *searchId(long id, node_t *root);

/**
   \brief Rimuove un identificatore dall'albero
   \param id   identificatore da rimuover
   \param root radice dell'albero
   \param F    funzione per deallocare l'elelemento dati del nodo
   \return     elemento dati del nodo rimosso, NULL se l'elemento non e' stato trovato
*/
data_t *removeId(long id, node_t **root, void (*F)(void*));


#endif 
