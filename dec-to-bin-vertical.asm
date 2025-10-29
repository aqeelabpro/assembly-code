[org 0x0100]
    jmp start

decimal_to_hex:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    mov bx,80
    mov ax,[bp+8]   ; rows
    mul bx
    add ax,[bp+6]   ; cols
    shl ax,1
    mov di,ax
    mov ax,[bp+10]  ; number
    mov bx,16       ; divisor
    mov cx,0
divider:
    mov dx,0
    div bx
    cmp dl,9
    jbe its_digit
    mov dh,byte[bp+4]   ; attr
    add dl,0x037
    push dx
    inc cx
    cmp ax,0
    jnz divider
    jmp return
its_digit:
    mov dh,byte[bp+4]    ; attribute byte
    add dl,0x030
    push dx
    inc cx
    cmp ax,0
    jnz divider
    jmp return
return:
    mov ax,0xb800
    mov es,ax
again:
    pop dx
    mov [es:di],dx
    add di,160
    loop again
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp      
    ret 8
start:
push word [number]
push word [rows]
push word [cols]
push word [attr]
call decimal_to_hex
mov ax,0x4c00
int 0x21



number: dw 1000
rows: dw 10
cols: dw 50
attr: dw 0x0007