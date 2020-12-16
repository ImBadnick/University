#!/bin/bash

if ! [ -f "../prova.txt" ]; then
    touch ../prova.txt
    more refildata.txt > prova.txt
fi

if ! [ -f "../ciao.txt" ]; then
    touch ../ciao.txt
fi