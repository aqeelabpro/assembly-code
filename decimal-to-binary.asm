[org 0x0100]
    jmp start

decimal_to_binary:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    mov cx,0
    mov bx,2   ; binary divisor
    mov di,0
    mov cx,0xb800
    mov es,cx
    mov cx,0
priner:
    mov dx,0
    div bx
    mov dh,0x07     ; attribute byte
    add dl,0x30     ; number + '0'
    push dx
    inc cx
    cmp ax,0
    jnz priner
    jmp return
return:
again:
    pop dx
    mov [es:di],dx
    add di,2
    mov dl,' '      ; space character
    mov [es:di],dx
    add di,2
    loop again
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
    call decimal_to_binary

    mov ax,0x4c00
    int 0x21


number: dw 10    