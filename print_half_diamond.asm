[org 0x0100]
jmp start

;----------------------------------------
; print_triangle
; Prints a triangle of stars starting at (row, col)
; Stack parameters:
;   [bp+4]  = attribute byte
;   [bp+6]  = column (0-based)
;   [bp+8]  = row (0-based)
;   [bp+10] = number of rows (height)
;----------------------------------------
print_triangle:
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

    mov cx, [bp+10]            ; total rows to print
    xor si, si                 ; current row counter (0-based)
    mov bl, [bp+4]             ; attribute byte
    mov bh, 0                  ; high byte for AX

outer_loop:
    mov ax, [bp+8]             ; starting row
    add ax, si                 ; current row = start + si
    mov dx, 80
    mul dx                      ; ax = row * 80
    add ax, [bp+6]             ; add starting column
    shl ax, 1                   ; multiply by 2 for bytes
    mov di, ax                  ; offset in video memory

    ; print stars for this row (si + 1 stars)
    mov cx, si
    inc cx                      ; number of stars = current row index + 1

inner_loop:
    cmp cx,0
    je next_row
    mov al,'*'
    mov ah, bl            ; attribute
    mov [es:di], ax       ; print star
    add di,2              ; move to next cell
    mov al,' '            ; space
    mov ah, bl            ; same attribute
    mov [es:di], ax
    add di,2              ; move to next cell after space
    dec cx
    jmp inner_loop

next_row:
    inc si                      ; next row
    cmp si, [bp+10]             ; finished all rows?
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
start:
    push word [height]  ; number of rows in triangle
    push word [rows]    ; starting row
    push word [cols]    ; starting column
    push word [attr]    ; attribute
    call print_triangle

    mov ax, 0x4C00
    int 0x21

;----------------------------------------
; data
;----------------------------------------
height: dw 5       ; triangle height
rows:   dw 10      ; starting row
cols:   dw 50      ; starting column
attr:   dw 0x07    ; white-on-black