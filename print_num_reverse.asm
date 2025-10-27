[org 0x0100]

    jmp start

print_rev:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    mov cx,0
    mov bx,10   ; divisor
    mov di,0
    mov cx,0xb800
    mov es,cx
    mov cx,0
nextDigit:
    mov dx,0
    div bx
    mov dh,0x07     ; attribute byte
    add dl,0x30     ; number + '0'
    mov [es:di],dx
    add di,2
    mov dl,' '      ; space character
    mov [es:di],dx
    add di,2
    cmp ax,0
    jnz nextDigit
    jmp return
return:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret    

start:
    mov ax,[number]
    call print_rev

    mov ax,0x4c00
    int 0x21


number: dw 12345