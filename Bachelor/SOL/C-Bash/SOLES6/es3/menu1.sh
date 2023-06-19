#!/bin/bash
FILE1=$1
FILE2=$2

echo "1) Rimuovere i file "$FILE1" ed "$FILE2""
echo "2) Archiviare i file "$FILE1" ed "$FILE2""
echo "3) Appendere il file "$FILE1" al file "$FILE2""
echo "4) Esci"

if [ $# = 2 ]; then
    while [ true ]; do 
    echo -n "Scelta?"
    read option
        case $option in
            ("1") 
                if [ -f $FILE1 ]; then
                    rm -i $FILE1
                else
                    echo "$0: Error on removing file "$FILE1" --> file doesn't exists" 1>&2
                fi
                if [ -f $FILE2 ]; then
                    rm -i $FILE2
                else 
                    echo "$0: Error on removing file "$FILE2"  --> File doesn't exists" 1>&2
                fi ;;
            
            ("2") 
                if [ -f $FILE1 ] && [ -f $FILE2 ]; then
                    tar -cf - $FILE1 $FILE2 | gzip -9 > "${FILE1%.txt}${FILE2%.txt}.tar.gz"
                else 
                    echo "$0: $FILE1 and $FILE2 doesn't exists" 1>&2
                fi ;; 

            ("3") 
            if [ -f $FILE1 ]; then
                    if ! [ -f $FILE2 ]; then
                        touch $FILE2
                    fi
                    cat $FILE1 >> $FILE2
                else 
                    echo "$0: "$FILE1" file to append doesn't exists" 1>&2
                fi ;;
            
            ("4") break ;;

            (*) echo "Error in the option inserted" 1>&2
        esac
    done
else 
    echo "$0: Number of parameters must be 2!" 1>&2
fi