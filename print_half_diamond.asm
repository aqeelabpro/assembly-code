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
    xor si, si                 ; triangle row counter
    
inc_part_outer:
    mov ax, [bp+8]             ; maintaining row
    mov bx, si
    shl bx, 1                  ; bx = si * 2 (skip one line)
    add ax, bx                 ; ax = main_row + (si*2)
    mov dx, 80
    mul dx
    add ax, [bp+6]             ; maintaining column
    shl ax, 1
    mov di, ax

    mov cx, si
    shl cx, 1
    inc cx                     ; cx = 2*si + 1 stars

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

    mov bx, [bp+10]
    mov si, bx
    sub si, 2          ; height - 2 (middle row is common)

dec_part:
    cmp si, 0FFFFh
    je done

    ; row = (main_row + (height*2 - 2)) + ((height - 2 - si) * 2)
    ; meaning it mains just after top triangle
    mov ax, [bp+8]
    mov bx, [bp+10]
    shl bx, 1
    sub bx, 2
    add ax, bx               ; bottom main = just below top triangle
    mov bx, [bp+10]
    sub bx, si
    dec bx
    shl bx, 1
    add ax, bx
    mov dx, 80
    mul dx
    add ax, [bp+6]
    shl ax, 1
    mov di, ax

    mov cx, si
    shl cx, 1
    inc cx              ; cx = 2*si + 1 stars

print_dec_row:
    cmp cx, 0
    je next_dec
    mov al, '*'
    mov ah, 0x07
    mov [es:di], ax
    add di, 2
    dec cx
    jmp print_dec_row

next_dec:
    dec si
    jns dec_part

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
    push word [rows]    ; maintaining row
    push word [cols]    ; maintaining column
    push word [attr]    ; attribute
    call print_stars

    mov ax, 0x4C00
    int 0x21

;----------------------------------------
; data
;----------------------------------------
height: dw 5       ; triangle height
rows:   dw 5       ; maintaining row
cols:   dw 0       ; maintaining column
attr:   dw 0x07    ; white-on-black