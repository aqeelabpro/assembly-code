[org 0x0100]
jmp main

main:
    mov bx, 1234     ; 04D2 -> 24D0

    mov ax, bx          ; bx = 1234
    and ax, 0xF000     ; isolate high nibble - ax = 1000
    shr ax, 12          ; move it to low position - ax = 0001

    mov dx, bx          ; dx = 1234
    and dx, 0x0000F       ; isolate low nibble dx = 0004
    shl dx, 12          ; move it to high position dx = 4000

    mov cx, bx          ; cx = 1234
    and cx, 0FF0h       ; keep middle bits intact   cx = 0230

    or ax, dx           ; combine swapped outer nibbles ax = 4001
    or ax, cx           ; add middle unchanged part ax = ax = 4321

    mov bx, ax          ; BX now has final swapped value bx = 4321

    mov ax, 0x4c00
    int 0x21