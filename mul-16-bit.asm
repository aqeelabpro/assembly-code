[org 0x0100]

mov ax,50         ; AX = 0032
mov bx,10         ; BX = 000A
mul bx            ; AX * BX = 0032 * 000A = 01F4
                  ; Result → AX = 0032h
                  ; AH = 00h (high byte)
                  ; AL = 32h (low byte)
mov ax,0x4c00     ; DOS terminate program
int 0x21