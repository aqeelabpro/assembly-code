[org 0x0100]
jmp start

bin_to_octal:
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si

    mov cx,0
    mov bx,8       ; octal divisor
    mov di,0
    mov ax,0xb800
    mov es,ax
    mov ax,[number]

priner:
    mov dx,0
    div bx
    cmp dl,9
    jbe its_digit
    mov dh,0x07       ; attribute byte
    add dl,0x37         ; make correct ascii for A-F
    push dx
    inc cx
    cmp ax,0
    jnz priner
    jmp return

its_digit:
    mov dh,0x07       ; attribute byte
    add dl,0x30       ; number + '0'
    push dx
    inc cx
    cmp ax,0
    jnz priner
    jmp return

return:
again:
    cmp cx,0
    je done_print
    pop dx
    mov [es:di],dx
    add di,2
    mov dl,' '       ; space character
    mov [es:di],dx
    add di,2
    dec cx
    jmp again

done_print:
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
    call bin_to_octal

    mov ax,0x4c00
    int 0x21

number: dw 100
