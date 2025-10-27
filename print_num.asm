[org 0x0100]
jmp start

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

    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov cx, 0           ; digit counter
    mov ax,[bp+4]       ; number (4529)

pushDigits:
    mov dx, 0           
    div bx              
    add dl, 0x30        
    mov dh, 0x07        
    push dx             
    inc cx
    cmp ax, 0
    jnz pushDigits
    
printDigits:
    pop dx
    mov [es:di], dx
    add di, 2
    loop printDigits
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp,bp
    pop bp
    ret 2

start:
    mov bx, 10
    mov ax, [number]
    push word [number]
    call print

    mov ax, 0x4c00
    int 0x21

number: dw 4529