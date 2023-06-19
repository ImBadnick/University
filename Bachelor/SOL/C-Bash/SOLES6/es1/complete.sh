#!/bin/bash                    

if [ $# -ne 1 ]; then                        # Se il numero di parametri è diverso da 1
    echo usa: $(basename $0) nomedirectory   # Stampa "usa: nomedelprogramma nomedirectory"
    exit -1
fi
dir=$1
if [ ! -d $dir ]; then                       # Se non esiste la directory contenuta nella var dir
    echo "L'argomento $dir non e' una directory"   
    exit 1;   
fi

bdir=$(basename $dir)
if [ -f $bdir.tar.gz ] && [ -w $bdir.tar.gz ]; then                     # il file esiste ed e scrivibile
    echo "il file $bdir.tar.gz esiste gia', sovrascriverlo (S/N)?"
    read yn                                 # Legge da stdin
    if [ "$yn" != "S" ]; then               # Se il carattere letto è diverso da "S" esci
          exit 0;
    fi
    rm -f $bdir.tar.gz
fi
echo "creo l'archivio con nome $bdir.tar.gz"

tar cf $bdir.tar $dir 2>>error.txt     # appende l’output sullo std-error nel file error.txt   
if [ $? -ne 0 ]; then                         # controlla che il comando sia andato a buon fine
    echo "Errore nella creazione dell'archivio"
    exit 1
fi
gzip $bdir.tar  2>>error.txt                  # appende l’output sullo std-error nel file error.txt
if [ $? -ne 0 ]; then                         # controlla che il comando sia andato a buon fine
    echo
    echo "Errore nella compressione dell'archivio"
    exit 1
fi

echo "archivio creato con successo, il contenuto dell’archivio e':"
tar tzvf $bdir.tar.gz   2>&1           # redirige lo std-error sullo std-output
exit 0