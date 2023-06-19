# Makefile Completato! 
CC		=  gcc
CFLAGS  = -Wall -std=c99 -I./include/ 
ObjFlags = -c -fPIC -I./include/ -o
Parametri = 5 -2 28

.PHONY: test1 clean

all: ./bin/myprog

./bin/myprog: ./lib/libbt.so ./src/myprog.c ./include/utils.h
	$(CC) ./src/myprog.c $(CFLAGS) -o $@ -L ./lib/ -lbt 

./lib/libbt.so: ./src/binarytree.o
	gcc -shared -o $@ $^

./src/binarytree.o: ./src/binarytree.c ./include/binarytree.h ./include/utils.h
	$(CC) ./src/binarytree.c $(ObjFlags) $@


test1:
	./bin/myprog $(Parametri) > out.txt 
	diff out.txt ./testfile/test1-out_atteso.txt ; if [ $$? -eq 0 ] ; then echo "test1 OK" ; fi
	
clean:
	rm ./src/binarytree.o
