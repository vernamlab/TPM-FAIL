default: client

client.o: client.c
	gcc -c client.c -o client.o -w

client: client.o
	gcc client.o -o client

clean:
	-rm -f client.o
	-rm -f client