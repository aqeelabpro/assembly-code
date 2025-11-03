[org 0x0100]
    jmp main
; specific location formula
;   offset = ( (rows * 80) + cols ) * 2

print:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    xor di,di               ; clear di
    xor ax,ax               ; clear ax

    xor dx,dx               ; clear dx

    mov ax,[bp+6]           ; rows
    mov bx,80               ; included in formula
    mul bx                  ; ax = ax * bx
    add ax,[bp+4]           ; add cols
    shl ax,1                ; ax * 2
    mov di,ax               ; di = ax = offset = ( (rows * 80) + cols ) * 2
    mov bx,[bp+10]          ; base to print the number in
    xor cx,cx               ; clear cx
    mov ax,[bp+12]          ; number
nextDigit:
    mov dx,0                ; clear dx
    div bx
    mov dh,[bp+8]
    cmp dl,9
    jbe its_digit
    ; if hex
    add dl,0x037
    push dx
    inc cx
    cmp ax,0
    jnz  nextDigit
    jmp return
its_digit:
    mov dh,[bp+8]
    add dl,0x030
    push dx
    inc cx
    cmp ax,0
    jnz  nextDigit
    jmp return
return:
    mov ax,0xb800
    mov es,ax
    again:
        pop dx
        mov [es:di],dx
        add di,2
        mov dl,' '          ; space
        mov [es:di],dx
        add di,2
        loop again
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
        ret 10

main:
    push word [num]
    push word [base]
    push word [attribute]
    push word [rows]
    push word [cols]
    call print
    mov ax,0x4c00
    int 0x21

num: dw 0x0064
base: dw 10    ; base to print in
attribute: dw 0x007
rows: dw 0
cols: dw 0