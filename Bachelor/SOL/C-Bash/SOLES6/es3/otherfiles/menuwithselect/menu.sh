#!/bin/bash
FILE1=$1
FILE2=$2

if [ $# = 2 ]; then
    PS3="Scelta?"
    select option in "Rimuovere i file "$FILE1" ed "$FILE2"" \
                   "Archiviare i file "$FILE1" ed "$FILE2""\
                   "Appendere il file "$FILE1" al file "$FILE2""\
                   "Esci"; do
        case $option in
            ("Rimuovere i file "$FILE1" ed "$FILE2"") 
                if [ -f $FILE1 ]; then
                    rm $FILE1
                else
                    echo "$0: Error on removing file "$FILE1"" 1>&2
                fi
                if [ -f $FILE2 ]; then
                    rm $FILE2
                else 
                    echo "$0: Error on removing file "$FILE2"" 1>&2
                fi ;;
            
            ("Archiviare i file "$FILE1" ed "$FILE2"") 
                if [ -f $FILE1 ] && [ -f $FILE2 ]; then
                    tar -czvf "${FILE1%.txt}${FILE2%.txt}.tar.gz" $FILE1 $FILE2
                else 
                    echo "$0: $FILE1 and $FILE2 doesn't exists" 1>&2
                fi ;; 

            ("Appendere il file "$FILE1" al file "$FILE2"") 
            if [ -f $FILE1 ]; then
                    if ! [ -f $FILE2 ]; then
                        touch $FILE2
                    fi
                    cat $FILE1 >> $FILE2
                else 
                    echo "$0: "$FILE1" file to append doesn't exists" 1>&2
                fi ;;
            
            ("Esci") break ;;

            (*) echo "Error in the option inserted" 1>&2
        esac
    done
else 
    echo "$0: Number of parameters must be 2!" 1>&2
fi