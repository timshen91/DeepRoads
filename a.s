.code16
.global _start

_start:
	mov $0x80000, %ebx
	mov $dummy_handler, %bx
	mov $dummy_handler, %ecx
	mov $0x8e00, %cx
	mov $0x7800, %eax
loop:
	subl $8, %eax
	mov %ebx, (%eax)
	mov %ecx, 4(%eax)
	cmp $7000, %eax
	jnz loop

	lgdt lgdt_op
	cli
	mov %cr0, %eax
	or $1, %eax
	movl %eax, %cr0
# Steal from Linux
	.byte 0x66, 0xea
	.long next
	.word 8

.code32
next:
	lidt lidt_op
	mov $16, %ecx
	mov %ecx, %ds
	mov %ecx, %es
	mov %ecx, %fs
	mov %ecx, %gs
	mov %ecx, %ss
	mov $0x6ffc, %esp
	sti

idle:
	jmp idle

.align 8
gdt:
	.quad 0
	.quad 0x00CF9A000000FFFF
	.quad 0x00CF92000000FFFF

lgdt_op:
	.word 23
	.long gdt

lidt_op:
	.word 255
	.long 0x7000

dummy_handler:
	iret
