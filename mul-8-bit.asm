[org 0x0100]

mov ax,5          ; AX = 0005
mov bx,10         ; BX = 000A
mul bl            ; AL * BL = 05h * 0Ah = 32h
                  ; Result → AX = 0032h
                  ; AH = 00h (high byte)
                  ; AL = 32h (low byte)
mov ax,0x4c00     ; DOS terminate program
int 0x21