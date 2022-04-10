all: cspci.img

cspci.img: cspci.asm Makefile
	nasm -f bin cspci.asm -o cspci.img
