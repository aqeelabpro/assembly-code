[org 0x0100]
jmp main

hex_to_hex:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    mov ax,0xb800
    mov es,ax
    mov bx,16
    mov ax,[bp+6]   ; number
    mov cx,0
    mov di,0

convert:
    mov dx,0
    div bx      ; ax/bx
    mov dh,byte [bp+4]  ; attr
    cmp dl,9
    jbe its_digit
    add dl,0x37
    push dx
    inc cx
    cmp ax,0
    jnz convert
    jmp return
its_digit:
    mov dh,byte [bp+4]  ; attr
    add dl,0x030
    push dx
    inc cx
    cmp ax,0
    jnz convert
    jmp return
return:
    pop dx
    mov [es:di],dx
    add di,2
    loop return
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4 

main:
    push word [hex]
    push word [attribute]
    call hex_to_hex
    mov ax,0x4c00
    int 0x21

hex: dw 0xABCD
attribute: dw 0x0007