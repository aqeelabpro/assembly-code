; 128 bit extended multiplication
; 128/16 = 8 words(multiplier as multiplicand is already 128 bit but only 128 bits will be used)
[org 0x0100]
jmp start

start:
xor cx,cx
mov cl,128       ; as multiplier is 128 bits

checkbit:
    shr word [multiplier+14],1        ; always do shr on high word then rcr on all part below it
    rcr word [multiplier+12],1
    rcr word [multiplier+10],1
    rcr word [multiplier+8], 1
    rcr word [multiplier+6], 1
    rcr word [multiplier+4], 1
    rcr word [multiplier+2], 1
    rcr word [multiplier+0], 1
    
    jnc skip
    
    ; 256/16 = 16 words
    mov ax,   [multiplicand]         ; 0 word
    add [result],ax

    mov ax, [multiplicand+2]         ; 1 word
    adc [result+2],ax
    
    mov ax, [multiplicand+4]         ; 2 word
    adc [result+4],ax

    mov ax, [multiplicand+6]         ; 3 word
    adc [result+6],ax

    mov ax, [multiplicand+8]         ; 4 word
    adc [result+8],ax

    mov ax,[multiplicand+10]         ; 5 word
    adc [result+10],ax

    mov ax,[multiplicand+12]         ; 6 word
    adc [result+12],ax

    mov ax,[multiplicand+14]         ; 7 word
    adc [result+14],ax

    mov ax, [multiplicand+16]         ; 8 word
    adc [result+16],ax

    mov ax, [multiplicand+18]         ; 9 word
    adc [result+18],ax
    
    mov ax, [multiplicand+20]         ; 10 word
    adc [result+20],ax

    mov ax, [multiplicand+22]         ; 11 word
    adc [result+22],ax

    mov ax,[multiplicand+24]         ; 12 word
    adc [result+24],ax

    mov ax,[multiplicand+26]         ; 13 word
    adc [result+26],ax

    mov ax,[multiplicand+28]         ; 14 word
    adc [result+28],ax
    
    mov ax,[multiplicand+30]         ; 15 word
    adc [result+30],ax

skip:
    shl word [multiplicand+0], 1
    rcl word [multiplicand+2], 1
    rcl word [multiplicand+4], 1
    rcl word [multiplicand+6], 1
    rcl word [multiplicand+8], 1
    rcl word [multiplicand+10],1
    rcl word [multiplicand+12],1
    rcl word [multiplicand+14],1
    rcl word [multiplicand+16],1
    rcl word [multiplicand+18],1
    rcl word [multiplicand+20],1
    rcl word [multiplicand+22],1
    rcl word [multiplicand+24],1
    rcl word [multiplicand+26],1
    rcl word [multiplicand+28],1
    rcl word [multiplicand+30],1
    
    dec cl
    jnz checkbit
    jmp done
done:
    ; for printing
    mov ax,   [result]
    mov ax, [result+2]
    mov ax, [result+4]
    mov ax, [result+6]
    mov ax, [result+8]
    mov ax,[result+10]
    mov ax,[result+12]
    mov ax,[result+14]
    mov ax,[result+16]
    mov ax,[result+18]
    mov ax,[result+20]
    mov ax,[result+22]
    mov ax,[result+24]
    mov ax,[result+26]
    mov ax,[result+28]
    mov ax,[result+30]

    mov ax,0x4c00
    int 0x21    

multiplicand: dd 0xFFFFFFFF
              dd 0xFFFFFFFF
              dd 0xFFFFFFFF
              dd 0xFFFFFFFF
              dd 0
              dd 0
              dd 0
              dd 0      ; extend to 256 bit so, shl does not affect

multiplier:   dd 0xFFFFFFFF
              dd 0xFFFFFFFF
              dd 0xFFFFFFFF
              dd 0xFFFFFFFF

result:       dd 0
              dd 0
              dd 0
              dd 0
              dd 0
              dd 0
              dd 0
              dd 0      ; extend to 256 bit
