HEADERS = ../kernel/tpmttl.h

default: tpmttl

tpmttl.o: tpmttl_client.c $(HEADERS)
	gcc -c tpmttl_client.c -o tpmttl.o -w

tpmttl: tpmttl.o
	gcc tpmttl.o -o tpmttl

clean:
	-rm -f tpmttl.o
	-rm -f tpmttl