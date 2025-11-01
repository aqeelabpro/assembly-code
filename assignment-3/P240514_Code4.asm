[org 0x0100]
    jmp main

count_bits:
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push si
    
    mov bx, ax          ; Store original number in BX
    mov cx, 0           ; CL will count ones, CH will count zeros
    mov dx, 16          ; 16 bits to check (for word)
    
count_loop:
    shl bx, 1           ; Shift left, MSB goes to CF
    jc bit_is_one       ; If carry set, bit is 1
    
bit_is_zero:
    inc ch              ; Increment zero count
    jmp next_bit
    
bit_is_one:
    inc cl              ; Increment one count
    
next_bit:
    dec dx
    jnz count_loop
    
    pop si
    pop dx
    pop bx
    pop ax
    pop bp
    ret

process_word:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov ax, [bx+si]     ; Get the current array element
    
    ; Check if number is odd or even
    test ax, 1          ; Test least significant bit
    jnz odd_number      ; If LSB=1, number is odd
    
even_number:
    ; Even number - replace with number of zeros
    call count_bits     ; CL=ones, CH=zeros
    mov byte [bx+si], ch     ; Replace with zero count
    jmp process_done
    
odd_number:
    ; Odd number - replace with number of ones
    call count_bits     ; CL=ones, CH=zeros  
    mov byte [bx+si], cl     ; Replace with one count
    
process_done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

process_array:
    ; Main processing loop for the entire array
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    
    mov bx, arr1        ; Array address
    mov cx, [size]      ; Array size
    mov si, 0           ; Index
    
process_loop:
    call process_word   ; Process current element
    add si, 2           ; Move to next word (2 bytes)
    loop process_loop   ; Continue until CX=0
    
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret

display_array:
    ; Display array contents for debugging
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push dx
    
    mov bx, arr1        ; Array address
    mov cx, [size]      ; Array size
    mov si, 0           ; Index
    mov dx, 0           ; Counter for display
    
display_loop:
    mov ax, [bx+si]     ; Get array element
    ; The value is now in AX - you can examine it in debugger
    
    ; For AFD debugger, you can see the values at memory location arr1
    ; We'll just loop through so you can set breakpoint and check each value
    
    add si, 2           ; Move to next word
    inc dx              ; Increment counter
    cmp dx, cx
    jl display_loop
    
    pop dx
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret

main:
    ; Initialize array processing
    call process_array
    
    ; Display final array contents
    call display_array
    
    ; Exit program
    mov ax, 0x4c00
    int 0x21

; Data section
arr1: dw 1, 2, 3, 4
size: dw 4