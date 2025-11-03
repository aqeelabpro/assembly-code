[org 0x0100]
jmp main

;----------------------------------------
; print_stars
; Prints an increasing triangle of stars
;----------------------------------------
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
    
;----------------------------------------
; Increasing part (1, 3, 5, ...)
;----------------------------------------
inc_part_outer:
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

print_inc_row_inner:
    cmp cx, 0
    je next_inc
    mov al, '*'
    mov ah, 0x07
    mov [es:di], ax
    add di, 2
    dec cx
    jmp print_inc_row_inner

next_inc:
    inc si
    cmp si, [bp+10]
    jl inc_part_outer

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
