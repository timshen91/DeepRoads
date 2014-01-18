all: compile
	qemu-system-x86_64 -hda image

debug: compile
	qemu-system-x86_64 -s -S -hda image &
	gdb -tui -iex "source gdbscript"

compile:
	as boot.s -o boot.o
	gcc -std=c11 -nostdlib -S main.c
	as main.s -o main.o
	ld --oformat binary -T ldscript *.o -o image

clean:
	rm -f *.o image main.s

.PHONY: all clean b
