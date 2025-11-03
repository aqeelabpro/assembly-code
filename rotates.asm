[org 0x0100]
mov al,0b01110101   ; 0111 0101 (0x75)
rol al,1            ; 1110 1010 (0xEA)
ror al,1            ; 0111 0101 (0x75)
sar al,1            ; 0011 1010 (0x3A)
rcl al,1            ; 0111 0101 (0x75)
rcr al,1            ; 0011 1010 (0x3A)
mov ax,0x4c00
int 0x21