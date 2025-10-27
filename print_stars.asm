[org 0x0100]
    jmp start

print_stars:
    push ax
    push bx
    push cx
    push dx
    
    mov dx, [number]
    mov cx, 1               ; Start from row 1

outer:
    cmp cx, dx
    jg done
    
    mov bx, 0               ; Column counter
    mov ah, 0x02            ; DOS function to print character

inner:
    cmp bx, cx              ; Compare column with row number
    jge newline             ; If we've printed cx stars, print newline
    
    push dx                 ; Save row counter
    mov dl, '*'
    int 0x21
    
    mov dl, ' '
    int 0x21
    
    pop dx                  ; Restore row counter
    inc bx
    jmp inner

newline:
    push dx                 ; Save row counter
    mov dl, 0x0D            ; Carriage return
    int 0x21
    mov dl, 0x0A            ; Line feed
    int 0x21
    pop dx                  ; Restore row counter
    
    inc cx
    jmp outer

done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

start:
    call print_stars
    
    mov ax, 0x4c00
    int 0x21

number: dw 5