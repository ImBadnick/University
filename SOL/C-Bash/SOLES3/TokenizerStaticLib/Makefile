main.o : main.c libreria/libtokenizer.a
	gcc main.c -o main.o -L ./libreria -ltokenizer

libreria/libtokenizer.a: libreria/tokenizer_lib.o
	ar r libreria/libtokenizer.a libreria/tokenizer_lib.o

libreria/tokenizer_lib.o: libreria/tokenizer_lib.c 
	gcc -std=c99 -Wall libreria/tokenizer_lib.c -c -o libreria/tokenizer_lib.o


