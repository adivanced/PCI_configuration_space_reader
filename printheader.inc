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


; Strings for outputing info about the PCI device header of type 0x0

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