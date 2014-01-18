.code16
.global _start

SYS_SEC_SIZE = 1

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

# switch to protected mode
	lgdt lgdt_op
	cli
	mov $1, %eax
	mov %eax, %cr0
# steal from Linux
	.byte 0x66, 0xea
	.long next
	.word 8

.code32
next:
	mov $16, %eax
	mov %eax, %ds
	mov %eax, %es
	mov %eax, %fs
	mov %eax, %gs
	mov %eax, %ss

	mov $0x20, %eax
	mov %eax, %cr4

	mov $0, %eax
	mov %eax, %cr3

	//IA32_EFER.LME = 1
	mov $0xc0000080, %ecx
	rdmsr
	or $0x100, %eax
	wrmsr

	mov $0, %eax
	movl $0x1009, (%eax)
	movl $0, 4(%eax)

	mov $0x1000, %eax
	movl $0x2009, (%eax)
	movl $0, 4(%eax)

	mov $0x2000, %eax
	movl $0x3009, (%eax)
	movl $0, 4(%eax)

	mov $0x3000 + 7*8, %eax
	movl $0x7009, (%eax)
	movl $0, 4(%eax)

	mov $0x3000 + 7*8, %eax
	movl $0x7009, (%eax)
	movl $0, 4(%eax)

	// for stack
	mov $0x3000 + 0x1ff*8, %eax
	movl $0x1ff009, (%eax)
	movl $0, 4(%eax)

	//CR0.PG = 1
	mov %cr0, %eax
	or $0x80000000, %eax
	mov %eax, %cr0

	mov $0x1ffffc, %esp
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

lgdt_op:
	.word 23
	.long gdt
