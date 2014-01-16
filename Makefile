all: compile
	qemu-system-x86_64 -hda image

debug: compile
	qemu-system-x86_64 -s -S -hda image &
	gdb -tui -iex "source gdbscript"

compile:
	gcc -nostdlib main.c -S
	as boot.s -o boot.o
	as main.s -o main.o
	ld --oformat binary -Ttext 7c00 boot.o -o image
	ld --oformat binary -Ttext 7e00 main.o -o main.o
	echo -ne "\x55\xaa" | dd seek=510 bs=1 of=image
	dd seek=512 bs=1 if=main.o of=image

clean:
	rm -f a a.o b b.o

.PHONY: all clean b
