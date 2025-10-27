[org 0x0100]
jmp start

print:
    push ax
    push bx
    push cx
    push si
    push di
    push es
    mov ax,0xb800
    mov es,ax
    mov ax,0
    mov ah,0x07
printChar:
    mov al,[bx+si]
    mov [es:di],ax
    add di,2
    add si,1
    loop  printChar
    
    ; after loop
    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax 
    ret           

start:
    mov bx,string
    mov cx,[len]
    mov si,0    ; move to next char
    mov di,0    ; location teller
    call print
    mov ax,0x4c00
    int 0x21


string: db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
len: dw 26