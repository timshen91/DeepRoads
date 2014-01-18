all: compile
	qemu-system-x86_64 -hda image

debug: compile
	qemu-system-x86_64 -s -S -hda image &
	gdb -tui -iex "source gdbscript"

compile:
	gcc -nostdlib -S main.c
	as boot.s -o boot.o
	as main.s -o main.o
	ld --oformat binary -Ttext 7c00 boot.o -o image
	ld --oformat binary -Ttext 7e00 main.o -o main
	echo -ne "\x55\xaa" | dd seek=510 bs=1 of=image
	dd seek=512 bs=1 if=main of=image

clean:
	rm -f *.o image main main.s

.PHONY: all clean b
