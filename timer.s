.global set_timer

APIC = 0xfee00000
DCR = 0x3e0
ICR = 0x380
CCR = 0x390
EOI = 0x0b0
SVR = 0x0f0
TIMER_LVT = 0x320
ERROR = 0x280

set_timer:
	mov $128, %eax
	movl $timer_handler, (%eax)
	movl $spurious_handler, 4(%eax)

	mov $APIC+ICR, %eax
	movl $1000000, (%eax)

	mov $APIC+DCR, %eax
	movl $0x0, (%eax)

	mov $APIC+SVR, %eax
	movl $0x121, (%eax)

	mov $APIC+TIMER_LVT, %eax
	movl $0x20020, (%eax)

	ret

putchar:
	push %ax
	mov $0x0e, %ah
	mov %dl, %al
	int $0x10
	pop %ax
	ret

timer_handler:
	mov $'A', %dl
	call putchar
	mov $APIC+EOI, %edi
	movl $0, (%edi)
	iret

spurious_handler:
	mov $APIC+EOI, %edi
	movl $0, (%edi)
	iret
