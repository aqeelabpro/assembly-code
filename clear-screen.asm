[org 0x0100]
    jmp main
clrscr:
    push ax
    push si
    push di
    push es
    mov ax,0xb800
    mov es,ax
    mov ax,0
    mov ah,0x07   ; attribute
    mov al,0x20
    mov di,0
clear:
    mov [es:di],ax
    add di,2
    cmp di,4000
    jnz clear
    pop es
    pop di
    pop si
    pop ax
    ret
main:
    call clrscr
    mov ax,0x4c00
    int 0x21    