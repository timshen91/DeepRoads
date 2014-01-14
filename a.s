.code16
.global _start
_start:
	mov $str, %edi
	call puts
idle:
	jmp idle

puts:
	push %eax
	mov %edi, %eax
	puts_1b:
		mov (%eax), %dl
		cmp $0, %dl
		jz puts_1f
		call putchar
		inc %eax
		jmp puts_1b
	puts_1f:
	pop %eax
	ret

putchar:
	push %ax
	mov $0x0e, %ah
	mov %dl, %al
	int $0x10
	pop %ax
	ret

str:
	.string "hello, world\r\n"
