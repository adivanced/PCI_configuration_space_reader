[BITS 16]
[org 0x7c00]


;MACROS ________________________________________________________________________________________________________________________________

; a macro, written for simplicity. All PCI bus communications done in this macro.
%macro call_r_pci 4
	mov ax, word [%1]
	mov bx, word [%2]
	mov dx, word [%3]
	mov cx, %4
	mov si, pcidwrd
	call pci_config_read_word
%endmacro

; a macro used to add an ignored Vendor ID for the process of the PCI bus scan. In order to add one, follow the instructions, given at the line 126
%macro ignore 1
	cmp word [pcidwrd], %1
	je _inc_bsf
%endmacro

;______________________________________________________________________________________________________________________________________



; MBR: ================================================================================================================================
; program`s start: clear the es segment register and load the code, that exceeds the 512 bytes lmit.

mov ax, 0
mov es, ax

mov ah, 0x02
mov al, 9 ; 512 * al to read
mov ch, 0
mov dh, 0
mov cl, 2
mov bx, stage2
int 0x13

jmp 0x7e00


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

jtbl db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'

outstr1 	  db "Vendor ID: 0x0000 Device ID: 0x0000", 0,
outstr2	  	  db "Status: 0x0000 Command: 0x0000", 0,
outstr3		  db "Clcode 0x00 Subcl 0x00 progIF 0x00 revID 0x00", 0,
outstr4		  db "BIST 0x00 htype 0x00 ltmr 0x00 chlsz 0x00", 0,
outstr5		  db "BAR0 0x00000000", 0,
outstr6		  db "BAR1 0x00000000", 0,
outstr7		  db "BAR2 0x00000000", 0,
outstr8		  db "BAR3 0x00000000", 0,
outstr9		  db "BAR4 0x00000000", 0,
outstrA		  db "BAR5 0x00000000", 0,
outstrB		  db "Crdbus CIS ptr 0x00000000", 0,
outstrC		  db "Sybsys ID: 0x0000 Sybsys vendor ID: 0x0000", 0,
outstrD		  db "Expansion ROM BAR 0x00000000", 0,
outstrE		  db "Capabilities ptr 0x00", 0,
outstrF		  db "Max lat 0x00 Min Grant 0x00 INT PIN 0x00 INT line 0x00", 0

times 510 - ($-$$) db 0
dw 0xAA55  																															  

;======================================================================================================================================


; SECOND STAGE:+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

stage2:

xor ax, ax
mov ds, ax
mov es, ax

; establish the stack 
mov sp, 0xffff

; enable the BIOS default text mode
mov ah, 0x00
mov al, 0x03  ; text mode 80x25 16 colours
int 0x10

xor di, di


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

htp0:

call newln

call_r_pci pci_bus, pci_slot, pci_func, 0

mov ax, word [pcidwrd]
mov di, outstr1+16
call cvt2hex

mov ax, word [pcidwrd+2]
mov di, outstr1+34
call cvt2hex

mov si, outstr1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x4

mov ax, word [pcidwrd+2]
mov di, outstr2+13
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstr2+29
call cvt2hex

mov si, outstr2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x8

mov al, byte [pcidwrd+3]
mov di, outstr3+10
call cvt2hex

mov al, byte [pcidwrd+2]
mov di, outstr3+21
call cvt2hex

mov al, byte [pcidwrd+1]
mov di, outstr3+33
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr3+44
call cvt2hex

mov si, outstr3		
call print
call newln

mov si, outstr4		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x10

mov eax, dword [pcidwrd]
mov di, outstr5+14
call cvt2hex_32

mov si, outstr5		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x14

mov eax, dword [pcidwrd]
mov di, outstr6+14
call cvt2hex_32

mov si, outstr6		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x18

mov eax, dword [pcidwrd]
mov di, outstr7+14
call cvt2hex_32

mov si, outstr7		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x1c

mov eax, dword [pcidwrd]
mov di, outstr8+14
call cvt2hex_32

mov si, outstr8		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x20

mov eax, dword [pcidwrd]
mov di, outstr9+14
call cvt2hex_32

mov si, outstr9		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x24

mov eax, dword [pcidwrd]
mov di, outstrA+14
call cvt2hex_32

mov si, outstrA		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x28

mov eax, dword [pcidwrd]
mov di, outstrB+24
call cvt2hex_32

mov si, outstrB
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x2c

mov ax, word [pcidwrd+2]
mov di, outstrC+16
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstrC+41
call cvt2hex

mov si, outstrC
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x30

mov eax, dword [pcidwrd]
mov di, outstrD+27
call cvt2hex_32

mov si, outstrD
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x34

xor ax, ax
mov al, byte [pcidwrd]
mov di, outstrE+20
call cvt2hex

mov si, outstrE
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x3c

xor ax, ax
mov al, byte [pcidwrd+3]
mov di, outstrF+11
call cvt2hex

mov al, byte [pcidwrd+2]
mov di, outstrF+26
call cvt2hex

mov al, byte [pcidwrd+1]
mov di, outstrF+39
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstrF+53
call cvt2hex

mov si, outstrF
call print
call newln

;clear_0

jmp _e_proc_dev

htp1:

call newln

call_r_pci pci_bus, pci_slot, pci_func, 0

mov ax, word [pcidwrd]
mov di, outstr1+16
call cvt2hex

mov ax, word [pcidwrd+2]
mov di, outstr1+34
call cvt2hex

mov si, outstr1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x4

mov ax, word [pcidwrd+2]
mov di, outstr2+13
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstr2+29
call cvt2hex

mov si, outstr2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x8

xor ax, ax

mov al, byte [pcidwrd+3]
mov di, outstr3+10
call cvt2hex

mov al, byte [pcidwrd+2]
mov di, outstr3+21
call cvt2hex

mov al, byte [pcidwrd+1]
mov di, outstr3+33
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr3+44
call cvt2hex

mov si, outstr3		
call print
call newln

mov si, outstr4		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x10

mov eax, dword [pcidwrd]
mov di, outstr5+14
call cvt2hex_32

mov si, outstr5		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x14

mov eax, dword [pcidwrd]
mov di, outstr6+14
call cvt2hex_32

mov si, outstr6		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x18
xor ax, ax

mov al, byte [pcidwrd+3]
mov di, outstr7_1+23
call cvt2hex

mov al, byte [pcidwrd+2]
mov di, outstr7_1+48
call cvt2hex

mov al, byte [pcidwrd+1]
mov di, outstr7_1+71
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr7_1+92
call cvt2hex

mov si, outstr7_1 
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x1c

mov ax, word [pcidwrd+2]
mov di, outstr8_1+22
call cvt2hex

xor ax, ax

mov al, byte [pcidwrd+1]
mov di, outstr8_1+37
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr8_1+51
call cvt2hex

mov si, outstr8_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x20

mov ax, word [pcidwrd+2]
mov di, outstr9_1+18
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstr9_1+37
call cvt2hex

mov si, outstr9_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x24

mov ax, word [pcidwrd+2]
mov di, outstrA_1+26
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstrA_1+55
call cvt2hex

mov si, outstrA_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x28
mov eax, dword [pcidwrd]
mov di, outstrB_1+41
call cvt2hex_32

mov si, outstrB_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x2C
mov eax, dword [pcidwrd]
mov di, outstrC_1+41
call cvt2hex_32

mov si, outstrC_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x30
mov ax, word [pcidwrd+2]
mov di, outstrD_1+29
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstrD_1+59
call cvt2hex

mov si, outstrD_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x34
xor ax, ax
mov al, byte [pcidwrd]
mov di, outstrE_1+18
call cvt2hex

mov si, outstrE_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x38
mov eax, dword [pcidwrd]
mov di, outstrF_1+27
call cvt2hex_32

mov si, outstrF_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x3c
mov ax, word [pcidwrd+2]
mov di, outstr10_1+20
call cvt2hex

xor ax, ax

mov al, byte [pcidwrd+1]
mov di, outstr10_1+33
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr10_1+47
call cvt2hex

mov si, outstr10_1
call print
call newln

;clear_1

jmp _e_proc_dev


htp2:

call newln

call_r_pci pci_bus, pci_slot, pci_func, 0

mov ax, word [pcidwrd]
mov di, outstr1+16
call cvt2hex

mov ax, word [pcidwrd+2]
mov di, outstr1+34
call cvt2hex

mov si, outstr1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x4

mov ax, word [pcidwrd+2]
mov di, outstr2+13
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstr2+29
call cvt2hex

mov si, outstr2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x8

mov al, byte [pcidwrd+3]
mov di, outstr3+10
call cvt2hex

mov al, byte [pcidwrd+2]
mov di, outstr3+21
call cvt2hex

mov al, byte [pcidwrd+1]
mov di, outstr3+33
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr3+44
call cvt2hex

mov si, outstr3		
call print
call newln

mov si, outstr4		
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x10

mov eax, dword [pcidwrd]
mov di, outstr5_2+32
call cvt2hex_32

mov si, outstr5_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x14

mov ax, word [pcidwrd+2]
mov di, outstr6_2+22
call cvt2hex

xor ax, ax
mov al, byte [pcidwrd]
mov di, outstr6_2+55
call cvt2hex

mov si, outstr6_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x18

xor ax, ax
mov al, byte [pcidwrd+3]
mov di, outstr7_2+25
call cvt2hex

mov al, byte [pcidwrd+2]
mov di, outstr7_2+50
call cvt2hex

mov al, byte [pcidwrd+1]
mov di, outstr7_2+71
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr7_2+88
call cvt2hex

mov si, outstr7_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x1c

mov eax, dword [pcidwrd]
mov di, outstr8_2+24
call cvt2hex_32

mov si, outstr8_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x20

mov eax, dword [pcidwrd]
mov di, outstr9_2+24
call cvt2hex_32

mov si, outstr9_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x24

mov eax, dword [pcidwrd]
mov di, outstrA_2+24
call cvt2hex_32

mov si, outstrA_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x28

mov eax, dword [pcidwrd]
mov di, outstrB_2+24
call cvt2hex_32

mov si, outstrB_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x2c

mov eax, dword [pcidwrd]
mov di, outstrC_2+24
call cvt2hex_32

mov si, outstrC_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x30

mov eax, dword [pcidwrd]
mov di, outstrD_2+24
call cvt2hex_32

mov si, outstrD_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x34

mov eax, dword [pcidwrd]
mov di, outstrE_2+24
call cvt2hex_32

mov si, outstrE_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x38

mov eax, dword [pcidwrd]
mov di, outstrF_2+24
call cvt2hex_32

mov si, outstrF_2
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x3c

mov ax, word [pcidwrd+2]
mov di, outstr10_1+20
call cvt2hex

xor ax, ax

mov al, byte [pcidwrd+1]
mov di, outstr10_1+33
call cvt2hex

mov al, byte [pcidwrd]
mov di, outstr10_1+47
call cvt2hex

mov si, outstr10_1
call print
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x40

mov ax, word [pcidwrd+2]
mov di, outstr11_2+22
call cvt2hex

mov ax, word [pcidwrd]
mov di, outstr11_2+46
call cvt2hex

mov si, outstr11_2
call print 
call newln

call_r_pci pci_bus, pci_slot, pci_func, 0x44

mov eax, dword [pcidwrd]
mov di, outstr12_2+40
call cvt2hex_32

mov si, outstr12_2
call print
call newln

jmp _e_proc_dev

htperr:
	mov si, outstr4
	call print
	call newln
	jmp _e_proc_dev


pci_config_read_word: ; ax - bus(8 bit), bx - slot(5 bit), dx - func(3 bit), cx - offset(8 bit), si - a ptr to dword to be out, return - 32 bit value in a given memory location in si
	mov dword [si], 0x80000000
	shl eax, 16
	shl ebx, 11
	shl edx, 8
	and cl, 0xfc
	or dword [si], eax
	or dword [si], ebx
	or dword [si], edx
	or dword [si], ecx

	mov dx, 0xcf8
	mov di, si
	outsd 
	mov dx, 0xcfc
	insd
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
cvt2hex_32: ; umber in eax, pointer to the end of string in di
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

stoi_16: ; si = last digit, di = result
	xor cx, cx
	xor ax, ax
	xor bx, bx
	._loop:
		mov al, byte [si]
		cmp al, 'a'
		jae ._ftest
		cmp al, '0'
		jae ._stest	

		mov word [di], bx

		ret

		._ftpass:
			sub al, 'a'-10
			shl ax, cl
			add bx, ax
			dec si
			add cx, 4
			jmp ._loop

		._stpass:
			sub al, '0'
			shl ax, cl
			add bx ,ax
			dec si
			add cx, 4
			jmp ._loop

		._ftest:	
			cmp al, 'f'
			jbe ._ftpass
			mov word [di], bx

			ret
		._stest:
			cmp al, '9'
			jbe ._stpass
			mov word [di], bx
			ret



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


; a 32-bit unsigned integer to store the PCI bus`s response
pcidwrd dd 0

pci_bus dw 0
pci_slot dw 0
pci_func dw 0

input db "Bus: 0x0000 Slot: 0x00 Function: 0x0", 0

tst db "CONVERTED: Bus: 0x0000 Slot: 0x00 Function: 0x0", 0

nmsg db "!!!!", 0

outstr7_1 db "Secondary lat timer 0x00 Subordinate Bus num 0x00 Secondary Bus num 0x00 Primary Bus num 0x00", 0
outstr8_1 db "Secondary status 0x0000 I/O limit 0x00 I/O Base 0x00", 0
outstr9_1 db "Memory Limit 0x0000 Memory Base 0x0000", 0
outstrA_1 db "Prefetchable Mem lim 0x0000 Prefetchable Mem Base 0x0000", 0
outstrB_1 db "Prefetchable Base upper 32 bits  0x0000000", 0
outstrC_1 db "Prefetchable Limit upper 32 bits 0x0000000", 0
outstrD_1 db "I/O Limit upper 16 bits 0x0000 I/O Base upper 16 bits 0x0000", 0
outstrE_1 db "Capability ptr 0x00", 0
outstrF_1 db "Expansion ROM BAR 0x00000000", 0
outstr10_1 db "Bridge control 0x0000 INT PIN 0x00 INT line 0x00", 0


outstr5_2 db "CardBus Socket/ExCa BAR 0x0000000", 0
outstr6_2 db "Secondary Status 0x0000 Offset of Capabilities list 0x00", 0
outstr7_2 db "CardBus latency timer 0x00 Subordinate Bus num 0x00 CardBus Bus num 0x00 PCI Bus num 0x00", 0
outstr8_2 db "Memory BAR0    0x00000000", 0
outstr9_2 db "Memory Limit 0 0x00000000", 0
outstrA_2 db "Memory BAR1    0x00000000", 0
outstrB_2 db "Memory Limit 1 0x00000000", 0
outstrC_2 db "I/O BAR0       0x00000000", 0
outstrD_2 db "I/O Limit 0    0x00000000", 0
outstrE_2 db "I/O BAR1       0x00000000", 0
outstrF_2 db "I/O Limit 1    0x00000000", 0
; use outstr10_1
outstr11_2 db "Subsys Vendor ID 0x0000 Subsys Device ID 0x0000", 0
outstr12_2 db "16-bit PC Card legacy mode BAR 0x00000000", 0

fstr db "List of all detected PCI devices. Select with arrows&Enter", 0
lstr db "Page 0x00/0x00", 0

teststr db "Vendor id 0x0000 Device id 0x0000 Bus 0x00 Slot 0x00 Func 0x0", 0

infostr db "Press ESC to get back to selection screen", 0
infostr2 db "Selected device info:", 0

; amount of pages with devices
pgnum dw 0

; amount of devices
devcnt dw 0
 
times ((0x1400) - ($ - $$)) db 0x00


scanarray:
; consists of 8-byte structs 
;struct device{
;	uint16_t Vendor_id;
;	uint16_t Device_id;
;	uint16_t Bus; (looks like Bus_00000000b for alignment)
;	uint8_t Slot;
;	uint8_t Func;
;};
