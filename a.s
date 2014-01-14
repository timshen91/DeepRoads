.code16
.global _start
_start:
	movb $0x0e, %ah
	movl $str, %ebx
loop:
	movb (%ebx), %al
	cmpb $0, %al
	jz idle
	int $0x10
	inc %ebx
	jmp loop
idle:
	jmp idle
str:
	.string "hello, world\r\n"
