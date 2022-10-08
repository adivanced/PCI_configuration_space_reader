; a macro used to add an ignored Vendor ID for the process of the PCI bus scan. In order to add one, follow the instructions, given at the line 23
%macro ignore 1
	cmp word [pcidwrd], %1
	je _inc_bsf
%endmacro

; a macro, written for simplicity. All PCI bus communications done in this macro.
%macro call_r_pci 4
	mov ax, word [%1]
	mov bx, word [%2]
	mov dx, word [%3]
	mov cx, %4
	mov si, pcidwrd
	call pci_config_read_word
%endmacro


; a loop, in wich I scan the PCI bus and locate all devices. Values are written into the scanarray, located right after program`s code
scanloop:
	push di
	call_r_pci pci_bus, pci_slot, pci_func, 0	
	pop di
	ignore 0xffff	; if your PCI bus returns something other than 0x0000 or 0xffff in the Device id field for nonexistent devices, just type your own "ignore <your value>" right below the initial ignores.
	ignore 0x0000		  			
	mov eax, dword [pcidwrd]
	mov dword [scanarray+di], eax
	mov al, byte [pci_slot]
	mov ah, byte [pci_func]
	shl eax, 16
	mov ax, word [pci_bus]
	mov dword [di+scanarray+4], eax
	add di, 8
	_inc_bsf:
		inc word [pci_func]
		cmp word [pci_func], 8
		je _inc_slt
		jmp scanloop
	_inc_slt:
		mov word [pci_func], 0
		inc word [pci_slot]
		cmp word [pci_slot], 20h
		je _inc_bus
		jmp scanloop
	_inc_bus:
		mov word [pci_slot], 0
		inc word [pci_bus]
		cmp word [pci_bus], 100000000b
		jnz scanloop


mov word [devcnt], di

; get the number of pages, needed for printing all the devices. 

mov ax, di
xor dx, dx
shr ax, 3
mov bx, 23
div bx
test dx, dx
jz _get_pgnum
inc ax

_get_pgnum:
mov word [pgnum], ax	


mov ax, 0
mov bx, scanarray
call printpage
call hilight_selected

; a main loop, in wich user gives his inputs and the program, in response, prints pages, device configuration space, etc.
_main_loop:
	push ax
	push bx

	xor ax, ax
	int 16h

	cmp ah, 0x48
	je _up_pressed
	cmp ah, 0x4b
	je _left_pressed
	cmp ah, 0x4d
	je _right_pressed
	cmp ah, 0x50
	je _down_pressed
	cmp ah, 0x1c
	je _enter_pressed

	pop bx
	pop ax
jmp _main_loop

_up_pressed:
	pop bx
	pop ax

	mov dx, ax
	mov cx, ax
	mov si, ax

	shl si, 4
	shl cx, 3
	sub cx, dx
	add si, cx
	shl si, 3
	add si, scanarray

	cmp si, bx
	je _main_loop
	sub bx, 8
	call hilight_selected
	jmp _main_loop

_left_pressed:
	pop bx
	pop ax
	or ax, ax
	jz _main_loop

	dec ax
	mov dx, ax
	mov cx, ax
	mov bx, ax

	shl bx, 4
	shl cx, 3
	sub cx, dx
	add bx, cx
	shl bx, 3
	add bx, scanarray
	call printpage
	call hilight_selected	
	jmp _main_loop

_right_pressed:
	pop bx
	pop ax
	mov dx, ax
	inc dx
	cmp dx, word [pgnum]
	jz _main_loop

	inc ax
	mov dx, ax
	mov cx, ax
	mov bx, ax

	shl bx, 4
	shl cx, 3
	sub cx, dx
	add bx, cx
	shl bx, 3
	add bx, scanarray
	call printpage
	call hilight_selected
	jmp _main_loop

_down_pressed:
	pop bx
	pop ax

	mov dx, word [devcnt]
	add dx, scanarray
	sub dx, 8
	cmp bx, dx
	je _main_loop

	mov dx, ax
	mov cx, ax
	mov si, ax

	shl si, 4
	shl cx, 3
	sub cx, dx
	add si, cx
	shl si, 3
	add si, scanarray+22*8

	cmp si, bx
	je _main_loop
	add bx, 8
	call hilight_selected
	jmp _main_loop

_enter_pressed:
	mov si, sp
	mov si, word [si]

	mov ax, word [si+4]
	mov word [pci_bus], ax
	xor ax, ax
	mov al, byte [si+6]
	mov word [pci_slot], ax
	mov al, byte [si+7]
	mov word [pci_func], ax

	call proc_dev

	pop bx
	pop ax
	call printpage
	call hilight_selected
	jmp _main_loop

cli 
hlt

; get pci configuration space data of selected device and print it
proc_dev:
	mov ah, 0x00
	mov al, 0x03  
	int 0x10


	call_r_pci pci_bus, pci_slot, pci_func, 0xc

	xor ax, ax

	mov al, byte [pcidwrd+3]
	mov di, outstr4+8
	call cvt2hex

	mov al, byte [pcidwrd+2]
	mov di, outstr4+19
	call cvt2hex

	mov al, byte [pcidwrd+1]
	mov di, outstr4+29
	call cvt2hex

	mov al, byte [pcidwrd]
	mov di, outstr4+40
	call cvt2hex

	mov si, infostr2
	call print

	mov al, byte [pcidwrd+2]
	and al, 01111111b
	or al, al
	jz htp0
	cmp al, 1
	je htp1
	cmp al, 2
	je htp2
	jmp htperr

	_e_proc_dev:
		mov si, infostr
		call print
		call newln

		._wait_loop:
			xor ax, ax
			int 16h

			cmp ah, 1
			jne ._wait_loop

ret

; amount of devices
devcnt dw 0


