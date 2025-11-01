[org 0x0100]
jmp main

; -------------------------------------------------
; print: prints AX as decimal number on screen
;        input: AX = number, attribute = 07 (white)
; -------------------------------------------------
print:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov bx, 10              ; divisor for decimal extraction
    mov ax, [bp+4]          ; number to print
    mov cx, 0               ; digit counter
    mov dx, 0

    mov ax, [bp+4]
    cmp ax, 0
    jnz extract_digits
    ; handle zero specially
    mov ax, 0xb800
    mov es, ax
    mov byte [es:0], '0'
    mov byte [es:1], 0x07
    jmp done_print

extract_digits:
    mov ax, [bp+4]
    mov bx, 10
    mov di, 0

pushDigits:
    mov dx, 0
    div bx
    add dl, '0'
    push dx
    inc cx
    cmp ax, 0
    jnz pushDigits

    mov ax, 0xb800
    mov es, ax
    mov di, [print_offset]

printDigits:
    pop dx
    mov [es:di], dl
    mov byte [es:di+1], 0x07
    add di, 2
    loop printDigits

    mov [print_offset], di

done_print:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 2         ; clean up parameter (1 word = 2 bytes)


; -------------------------------------------------
; calculate: performs +, -, *, /, mod and prints all
; parameters: num1 [bp+8], num2 [bp+6]
; -------------------------------------------------
calculate:
    push bp
    mov bp, sp
    push ax
    push bx
    push dx

    mov ax, [bp+8]   ; num1
    mov bx, [bp+6]   ; num2

    ; addition
    add ax, bx
    push ax
    call print

    ; subtraction
    mov ax, [bp+8]
    sub ax, [bp+6]
    push ax
    call print

    ; multiplication
    mov ax, [bp+8]
    mov bx, [bp+6]
    mul bx
    push ax
    call print

    ; division
    mov dx, 0
    mov ax, [bp+8]
    mov bx, [bp+6]
    div bx
    push ax
    call print

    ; modulus
    mov dx, 0
    mov ax, [bp+8]
    mov bx, [bp+6]
    div bx
    push dx
    call print

    pop dx
    pop bx
    pop ax
    mov sp, bp
    pop bp
    ret 4     ; clean up 2 parameters (2 words = 4 bytes)


; -------------------------------------------------
; main
; -------------------------------------------------
main:
    mov word [print_offset], 0
    push word [num2]
    push word [num1]
    call calculate

    mov ax, 0x4c00
    int 0x21

; -------------------------------------------------
; Data Section
; -------------------------------------------------
num1: dw 100
num2: dw 5
print_offset: dw 0
