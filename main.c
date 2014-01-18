typedef unsigned long long u64;

static void set_idt(void) {
    static char str[] = "hello, world\n";
    static u64 idt[64];
    u64 id_entry;
    for (int i = 0; i < 32; i++) {
        idt[i] = id_entry;
    }
}

void main(void) {
    set_idt();
    while (1);
}
