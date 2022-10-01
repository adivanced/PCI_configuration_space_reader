; MBR: ================================================================================================================================
; program`s start: clear the es segment register and load the code, that exceeds the 512 bytes lmit.

mov ax, 0
mov es, ax

mov ah, 0x02
mov al, 10 ; 512 * al to read
xor ch, ch
xor dh, dh
mov cl, 2
mov bx, stage2
int 0x13

jmp 0x7e00

; these two functions are here just for the rational use of the first program's 512 bytes.

cvt2hex: 	; a function to convert a number into hexadecimal string di = a string we write into(its end), ax = number, also uses bx
	std
	._loop:
		push ax
		and ax, 0x000f
		mov bx, jtbl
		xlat 
		stosb
		pop ax
		shr ax, 4
		jnz ._loop
	mov al, '0'
	._loop2:
		cmp byte [di], 'x'
		je ._end
		stosb
		jmp ._loop2
._end:
	cld
ret

jtbl db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'

; a print function, made using BIOS 10h interrupt.
print: ; si - address of a string to output
	mov ah, 0x0e

	._loop:
		lodsb
		or al, al
		jz ._end
		int 10h
		jmp ._loop
	._end:
ret

; a function, that puts the cursor at the beginnig of the next string
newln:
	xor bh, bh

	xor ax, ax
	mov ah, 0x03
	int 10h

	mov ah, 0x02
	xor dl, dl
	add dh, 1
	int 10h
ret

; converts an unsigned 32-bit integer into a hexadecimal string. 
cvt2hex_32: ; number in eax, pointer to the end of string in di
	std
	._loop:
		push eax
		and eax, 0x0000000f
		mov bx, jtbl
		xlat 
		stosb
		pop eax
		shr eax, 4
		jnz ._loop
	mov al, '0'
	._loop2:
		cmp byte [di], 'x'
		je ._end
		stosb
		jmp ._loop2

._end:
	cld
ret

times 510 - ($-$$) db 0
dw 0xAA55  																															  

;======================================================================================================================================