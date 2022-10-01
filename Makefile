cspci.img: cspci.asm pages.inc printheader.inc mbr.inc mainloop.inc pciutil.inc
	nasm -f bin cspci.asm -o cspci.img