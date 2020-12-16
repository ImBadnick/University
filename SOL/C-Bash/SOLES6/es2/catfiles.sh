#!/bin/bash
i=$#
((i--))

if [ $# -ge "2" ]; then
    if ! [ -f "${@: -1}" ]; then
        touch "${@: -1}"
    fi
    if [ -f ${!i} ]; then
            cat ${!i} > "${@: -1}"
        else
            echo "${!i}: File doesn't exists" 1>&2
    fi 
    ((i--))
    while [ ${i} -gt "0" ]; do
        if [ -f ${!i} ]; then
            cat ${!i} >> "${@: -1}"
        else
            echo "${!i}: File doesn't exists" 1>&2
        fi 
    ((i--))
    done 
else 
    echo "$0: Number of arg not exact" 1>&2
fi 
