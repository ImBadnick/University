CC		=  gcc
Parametri = in.txt out.txt

.PHONY: test clean

all: mycp2.o mycp.o

mycp2.o: mycp2.c
	$(CC) mycp2.c -o $@

mycp.o: mycp.c
	$(CC) mycp.c -o $@


test:
		(time ./mycp.o $(Parametri) 2) &>> resultSC.txt
		(time ./mycp.o $(Parametri) 2) &>> resultCP.txt

		(time ./mycp.o $(Parametri) 256) &>> resultSC.txt
		(time ./mycp.o $(Parametri) 256) &>> resultCP.txt

		(time ./mycp.o $(Parametri) 1024) &>> resultSC.txt
		(time ./mycp.o $(Parametri) 1024) &>> resultCP.txt

		(time ./mycp.o $(Parametri) 4096) &>> resultSC.txt
		(time ./mycp.o $(Parametri) 4096) &>> resultCP.txt

		(time ./mycp.o $(Parametri) 8192) &>> resultSC.txt
		(time ./mycp.o $(Parametri) 8192) &>> resultCP.txt
	
clean:
	rm ./*.o
