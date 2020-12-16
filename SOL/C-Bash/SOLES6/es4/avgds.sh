#!/bin/bash

function test {
    if (( $(echo "$1 < 0" |bc -l) )); then
    temp=$(bc <<< "scale=2;$temp*-1")
    fi
}

for f in *.dat 
do
    sum=0
    count=0
    exec 3<$f
    while read -u 3 linea; do
        linea=$(echo $linea | cut -d' ' -f2)
        sum=$(bc <<< "scale=2;$linea+$sum")
        (( count++ ))
    done 
    avg=$(bc <<< "scale=2;$sum/$count")
    exec 3<$f
    sum=0
    while read -u 3 linea; do
        linea=$(echo $linea | cut -d' ' -f2)
        temp=$(bc <<< "$linea-$avg")
        test $temp
        temp=$(bc -l <<< "scale=2;e(2*l($temp))")
        #echo "$f quadrato:$temp"
        sum=$(bc <<< "scale=2;$temp+$sum")
        #echo $sum
    done
    temp=$(bc <<< "scale=2;$sum/$count")
    temp=$(bc <<< "scale=2;sqrt($temp)")
    echo "${f%.dat} $count $avg $temp"
done