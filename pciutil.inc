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



; a 32-bit unsigned integer to store the PCI bus`s response
pcidwrd dd 0

pci_bus dw 0
pci_slot dw 0
pci_func dw 0