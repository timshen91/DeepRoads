all:
	as a.s -o a.o
	ld --oformat binary -Ttext 7c00 a.o -o a
	echo -ne "\x55\xaa" | dd seek=510 bs=1 of=a
	qemu-system-x86_64 -hda a

debug:
	as a.s -o a.o
	ld --oformat binary -Ttext 7c00 a.o -o a
	echo -ne "\x55\xaa" | dd seek=510 bs=1 of=a
	qemu-system-x86_64 -s -S -hda a &
	gdb -tui -iex "source gdbscript"

clean:
	rm -f a a.o

.PHONY: all clean
