[org 0x0100]

push word [num1]
push word [num2]
push word [num3]
sub sp,2
sub sp,1
push bp
mov bp,sp
mov ax,[bp+6]


num1: dw 0x01
num2: dw 0xAB
num3: dw 0x20CD

; ┌────────────────────────────────────────────────────────────┐
; │      8086 STACK AFTER EXECUTION UP TO `mov bp, sp`         │
; │  (Initial SP = 0xFFFE)                                     │
; └────────────────────────────────────────────────────────────┘

;   Address    Content   Description
;  ----------  --------  ---------------------------------------
;   FFF3-FFF4  00 00     ← old BP pushed by `push bp`
;   FFF5       ??        local (1 byte, from `sub sp,1`)
;   FFF6-FFF7  ?? ??     local (2 bytes, from `sub sp,2`)
;   FFF8-FFF9  CD 00     pushed [num3] = 0x00CD
;   FFFA-FFFB  AB 00     pushed [num2] = 0x00AB
;   FFFC-FFFD  01 00     pushed [num1] = 0x0001
;   FFFE-FFFF  ----      (unused, higher addresses)

;   BP = FFF3
;   SP = FFF3

;   [bp+6] = word at address FFF9 → bytes (00 low, AB high)
;   → AX = 0xAB00