[BITS 16]
[org 0x7c00]

; an include file, that contains the MBR beginning of the program
%include "mbr.inc"


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

; an include file, that contains the program's main loop
%include "mainloop.inc"

; an include file, that contains functions and macros for interacting with the PCI bus
%include "pciutil.inc"

; an include file, that contains functions for printing PCI device headers
%include "printheader.inc"

; an include file, that contains functions for printing the list of pci devices in pages
%include "pages.inc"

 
times ((0x1600) - ($ - $$)) db 0x00


scanarray:
; consists of 8-byte structs 
;struct device{
;	uint16_t Vendor_id;
;	uint16_t Device_id;
;	uint16_t Bus; (looks like Bus_00000000b for alignment)
;	uint8_t Slot;
;	uint8_t Func;
;};