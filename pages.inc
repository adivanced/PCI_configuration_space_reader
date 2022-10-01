
; This function puts a cursor next to the selected item on the viewed page.
hilight_selected: ; ax = page number, bx - selected item(address in array) 
	mov dx, ax
	mov cx, ax
	mov si, ax

	shl si, 4
	shl cx, 3
	sub cx, dx
	add si, cx
	shl si, 3
	add si, scanarray 	; si = page`s Base Address

	mov dx, bx
	sub dx, si
	shr dx, 3
	inc dx

	push ax
	push bx

	mov ah, 02h
	xor bh, bh
	shl dx, 8
	mov dl, 61
	int 10h

	pop bx
	pop ax

ret

; This function prints all contents of a page, that holds a part of the detected PCI devices list
printpage: ;ax - page number, bx - selected item(address in array)
	push ax
	push bx
	mov ah, 0x00
	mov al, 0x03  
	int 0x10
	mov ah, 02h
	xor bh, bh
	xor dx, dx
	int 10h

	mov si, fstr
	call print
	call newln

	mov si, sp
	mov bx, word [si]
	mov ax, word [si+2]

	mov dx, ax
	mov cx, ax
	mov si, ax

	shl si, 4
	shl cx, 3
	sub cx, dx
	add si, cx
	shl si, 3
	add si, scanarray
	mov bp, si
	add bp, 22*8


	._loop:

		mov word ax, [si]
		mov di, teststr+15
		call cvt2hex

		mov word ax, [2+si]
		mov di, teststr+32
		call cvt2hex

		xor ax, ax

		mov byte al, [4+si]
		mov di, teststr+41
		call cvt2hex

		mov byte al, [6+si]
		mov di, teststr+51
		call cvt2hex

		mov byte al, [7+si]
		mov di, teststr+60
		call cvt2hex

		mov di, si

		mov si, teststr
		call print
		call newln

		mov si, di

		mov dword [teststr+12], '0000'
		mov dword [teststr+29], '0000'
		mov word [teststr+40], '00'
		mov word [teststr+50], '00'
		mov byte [teststr+60], '0'

		add si, 8

		mov di, word [devcnt]
		add di, scanarray
		cmp si, di
		jae ._end

		cmp si, bp
		jbe ._loop

	._end:

	mov ah, 02h
	xor bh, bh
	mov dh, 24
	mov dl, 33
	int 10h

	mov di, sp
	mov ax, word [di+2]

	inc ax
	mov di, lstr+8
	call cvt2hex

	mov ax, word [pgnum]
	mov di, lstr+13
	call cvt2hex

	mov si, lstr
	call print

	pop bx
	pop ax

ret


; amount of pages with devices
pgnum dw 0