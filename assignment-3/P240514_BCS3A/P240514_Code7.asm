; ; ------------------ PART C ------------------
[org 0x0100]
    jmp start

; Subroutine to display array in decimal on video memory
; Parameters (pushed in order):
;   [bp+10] - offset of array
;   [bp+8]  - row position
;   [bp+6]  - column position  
;   [bp+4]  - array size
display:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
    mov ax, 0xb800
    mov es, ax
    
    ; Calculate starting position: (row * 80 + col) * 2
    mov ax, [bp+8]          ; row
    mov bx, 80
    mul bx                  ; ax = row * 80
    add ax, [bp+6]          ; ax = row * 80 + col
    shl ax, 1               ; multiply by 2 for word addressing
    mov di, ax              ; di = starting position in video memory
    
    mov si, [bp+10]         ; si = array offset
    mov cx, [bp+4]          ; cx = array size
    
display_loop:
    cmp cx, 0               ; check if done
    je display_done
    
    push cx                 ; save counter
    push di                 ; save video position
    
    ; Get current array element and display it
    mov ax, [si]
    call print_decimal      ; AX=number, DI=position, ES already set
    
    ; Move to next array element and video position
    add si, 2               ; next word in array
    
    pop di                  ; restore video position
    ; Advance video position for next number (6 characters spacing)
    add di, 12              ; 6 chars * 2 bytes per char = 12
    
    pop cx                  ; restore loop counter
    dec cx
    jmp display_loop
    
display_done:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8

; Print decimal number
; AX = number, DI = video position, ES = 0xB800
print_decimal:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    
    mov bx, 10              ; divisor
    mov cx, 0               ; digit counter
    
    ; Handle zero case
    cmp ax, 0
    jne convert_digits
    mov byte [es:di], '0'
    mov byte [es:di+1], 0x07
    jmp print_done
    
convert_digits:
    ; Convert number to digits (push them on stack)
    cmp ax, 0
    je print_digits
    xor dx, dx
    div bx                  ; ax = quotient, dx = remainder
    add dl, '0'             ; convert to ASCII
    push dx                 ; push digit
    inc cx                  ; count digit
    jmp convert_digits
    
print_digits:
    ; Pop digits from stack and display them
    cmp cx, 0
    je print_done
    pop dx                  ; get digit
    mov [es:di], dl         ; store character
    mov byte [es:di+1], 0x07 ; attribute
    add di, 2               ; next video position
    dec cx
    jmp print_digits
    
print_done:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

; Subroutine to multiply array elements by a number
; Parameters:
;   [bp+8] - array size
;   [bp+6] - multiplier
;   [bp+4] - offset of array
multiply:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    
    mov si, [bp+4]          ; array offset
    mov cx, [bp+8]          ; array size
    mov bx, [bp+6]          ; multiplier
    
multiply_loop:
    cmp cx, 0
    je multiply_done
    
    mov ax, [si]            ; get array element
    mul bx                  ; ax = ax * bx
    mov [si], ax            ; store result (only lower 16 bits)
    add si, 2               ; next word
    dec cx
    jmp multiply_loop
    
multiply_done:
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6

start:
    ; Extract last 2 digits from roll number
    mov ax, [rollNo]
    and ax, 0x00FF          ; last 2 hex digits (0x14 = 20 decimal)
    
    ; Multiply array by last 2 digits
    push word [size]        ; array size
    push ax                 ; multiplier (20)
    push nums               ; array offset
    call multiply
    
    ; Display array in middle of screen
    push nums               ; array offset
    push word [rows]        ; row (12)
    push word [cols]        ; column (30)
    push word [size]        ; array size (5)
    call display
    
    ; Exit program
    mov ax, 0x4c00
    int 0x21

; Data section
nums: dw 1, 2, 3, 4, 5
rollNo: dw 0x0514
size: dw 5
rows: dw 12
cols: dw 30


;  ______________ PART B ___________________


[org 0x0100]
    jmp main

print_stars:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov ax, 0B800h
    mov es, ax                 ; video memory segment

    mov cx, [bp+10]            ; total rows (height)
    xor si, si                 ; triangle row counter (0-based)

outer_loop:
    mov ax, [bp+8]             ; starting row
    mov bx, si
    shl bx, 1                  ; bx = si * 2 (skip one line each)
    add ax, bx                 ; actual row = base + (si * 2)
    mov dx, 80
    mul dx
    add ax, [bp+6]             ; starting column
    shl ax, 1
    mov di, ax

    mov cx, si
    shl cx, 1
    inc cx                     ; number of stars = 2*si + 1

inner_loop:
    cmp cx, 0
    je next_row
    mov al, '*'
    mov ah, 0x07
    mov [es:di], ax
    add di, 2
    dec cx
    jmp inner_loop

next_row:
    inc si
    cmp si, [bp+10]
    jl outer_loop

done:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8

;----------------------------------------
; main program
;----------------------------------------
main:
    push word [height]  ; number of rows in triangle
    push word [rows]    ; starting row
    push word [cols]    ; starting column
    push word [attr]    ; attribute
    call print_stars

    mov ax, 0x4C00
    int 0x21

;----------------------------------------
; data
;----------------------------------------
height: dw 5       ; triangle height
rows:   dw 5       ; starting row
cols:   dw 0       ; starting column
attr:   dw 0x07    ; white-on-black
