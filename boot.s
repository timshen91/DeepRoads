.code16
.global _start

SYS_SEC_SIZE = 1
IDT_SIZE = 256

_start:
# copy main to 0x7e00
	mov $DAP, %ebx
	sub $0x7c00, %ebx
	mov %bx, %si
	mov $0x7c0, %ax
	mov %ax, %ds
	mov $0x42, %ah
	mov $0x80, %dl
	int $0x13
	mov $0, %ax
	mov %ax, %ds

# fill IDT
	mov $0x80000, %ebx
	mov $dummy_handler, %bx
	mov $dummy_handler, %ecx
	mov $0x8e00, %cx
	mov $idt, %eax
	add $IDT_SIZE, %eax
loop:
	subl $8, %eax
	mov %ebx, (%eax)
	mov %ecx, 4(%eax)
	cmp $idt, %eax
	jnz loop

# switch to protected mode
	lgdt lgdt_op
	cli
	mov %cr0, %eax
	or $1, %eax
	movl %eax, %cr0
# steal from Linux
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

	jmp 0x7e00

DAP:
	.byte 0x10
	.byte 0
	.word SYS_SEC_SIZE
	.word 0, 0x7e0
	.quad 1

.align 8
gdt:
	.quad 0
	.quad 0x00CF9A000000FFFF
	.quad 0x00CF92000000FFFF

.align 8
idt:
	.zero IDT_SIZE

lgdt_op:
	.word 23
	.long gdt

lidt_op:
	.word IDT_SIZE-1
	.long idt

dummy_handler:
	iret
