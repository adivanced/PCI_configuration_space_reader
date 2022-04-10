all: enum.img cspci.img uhci.img

enum.img: enum.asm Makefile
	nasm -f bin enum.asm -o enum.img

cspci.img: cspci.asm Makefile
	nasm -f bin cspci.asm -o cspci.img

uhci.img: uhci.asm Makefile
	nasm -f bin uhci.asm -o uhci.img