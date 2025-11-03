[org 0x0100]
jmp start

binarySearch:
    push bp
    mov bp, sp
    sub sp, 6              ; local variables: left, right, mid

    mov word [bp-2], 0     ; left = 0
    mov ax, [bp+6]         ; size
    dec ax
    mov [bp-4], ax         ; right = size - 1

looper:
    mov ax, [bp-2]         ; left
    cmp ax, [bp-4]
    jg not_found

    mov ax, [bp-2]
    add ax, [bp-4]
    shr ax, 1
    mov [bp-6], ax         ; mid

    mov bx, nums
    mov dx, [bp-6]
    shl dx, 1               ; multiply by 2 for word
    add bx, dx
    mov cx, [bx]            ; array[mid]
    mov dx, [bp+4]          ; key

    cmp cx, dx
    jz found
    jb go_right
    ja go_left

go_right:
    mov ax, [bp-6]
    inc ax
    mov [bp-2], ax
    jmp looper

go_left:
    mov ax, [bp-6]
    dec ax
    mov [bp-4], ax
    jmp looper

found:
    mov ax, [bp-6]      ; got the element
    jmp done

not_found:
    mov ax, -1             ; not found

done:
    mov sp, bp
    pop bp
    ret 4                   ; adjust according to number of args

start:
    mov ax,[size]
    mov bx,[key]
    push ax
    push bx     
    mov ax,0
    mov bx,0
    call binarySearch
    ; ax = index or -1
    mov ax, 0x4c00
    int 0x21

size: dw 5
key:  dw 4
nums: dw 1,2,3,4,5