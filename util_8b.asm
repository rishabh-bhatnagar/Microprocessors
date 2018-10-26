;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex_to_bcd_8b macro x
; assume x has 38                  // 0x38 = 56
xor ah, ah;         ax <-- 00 xx
mov al, x;          ax <-- 00 38     // 38 is hex equivaent of 56.
aam;                ax <-- 05 06

; what if number entered is >= 100, ah will become 0A.
mov cx, ax ; temporarily storing before comparision.
cmp ah, 09
jg print_1
mov ax, cx
jmp normal

print_1 : mov al, 1
print_4b al
mov ax, cx
; suppose  123 was the number in dec,
; ax would have ax <-- 0C 03
; cx <-- 0B 02

mov al, ah        ; ax <-- 0C 0C
aam               ; ax <-- 01 02
mov ah, al        ; ax <-- 02 02
mov al, cl        ; ax <-- 02 03

normal :ror ah, 04;   ax <-- 50 06
add al, ah;           ax <-- 50 56
mov x, al;             x <-- 56


exit :

endm;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bcd_to_hex_8b macro x
; assume x has 56  ; 56 = 0x38

; what aad does is consider ah as higher bit and
; al as lower bit of bcd number
; and stores hex of ah, al in al
; So, for us, 03 should be in ah and al should have 08.

mov ah, x  ;        ax <-- 38 xx
mov al, x  ;        ax <-- 38 38
ror ah, 04 ;        ax <-- 83 38
and ah, 0fh;        ax <-- 03 38
and al, 0fh;        ax <-- 03 08
aad
mov x, al
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

add_bcd_8b macro x, y
bcd_to_hex_8b x
bcd_to_hex_8b y

mov al, x
add al, y

hex_to_bcd_8b x
hex_to_bcd_8b y
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_4b macro x
mov ah, 02
mov dl, x
add dl, '0'
int 21h
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_8b macro x
; assuming x <-- 56

; printing higher digit : 
mov dl, x        ; dl <-- 56
ror dl, 04       ; dl <-- 65
and dl, 0fh      ; dl <-- 05
print_4b dl

;printing lower digit
mov dl, x
and dl, 0fh
print_4b dl

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;#############################################################################

code segment
assume cs:code
start:
mov bl, 23h;
mov bh, 100;


hex_to_bcd_8b bh
print_8b bh

mov ah, 4ch
int 21h

code ends
end start

;#############################################################################
