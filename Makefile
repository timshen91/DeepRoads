all:
	as a.s -o a.o
	ld --oformat binary -Ttext 7c00 a.o -o a
	echo -ne "\x55\xaa" | dd seek=510 bs=1 of=a

clean:
	rm -f a a.o

.PHONY: all clean
